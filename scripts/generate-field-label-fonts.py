"""Generate MAX2's small complete-name CJK fonts from licensed Noto Sans SC.

Usage: python scripts/generate-field-label-fonts.py --font /path/NotoSansSC.ttf
Font source: https://github.com/notofonts/noto-cjk (SIL OFL 1.1).
Only the glyphs used by fieldChineseLabel are embedded in the bitmap fonts.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
WIDTHS = (240, 260, 280, 390, 416, 454, 466)
SIZES = {240: 9, 260: 10, 280: 10, 390: 15, 416: 16, 454: 17, 466: 17}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--font', required=True, type=Path)
    args = parser.parse_args()
    source = (ROOT / 'source/CNWatchFaceView.mc').read_text(encoding='utf-8-sig')
    body = re.search(r'private function fieldChineseLabel\(.*?\n    }', source, re.S)[0]
    label_map = dict(re.findall(r'if \(field == (FIELD_\w+)\) \{ return "([^"]+)";', body))
    labels = list(label_map.values())
    word_body = re.search(r'private function fieldChineseWords\(.*?\n    }', source, re.S)[0]
    word_map = {field: re.findall(r'"([^"]+)"', items) for field, items in
                re.findall(r'if \(field == (FIELD_\w+)\) \{ return \[(.*?)\];', word_body)}
    for field, label in label_map.items():
        assert ''.join(word_map.get(field, [label])) == label, field
    chars = sorted(set(''.join(labels) + ' '), key=ord)
    summary = {'sourceSha256': hashlib.sha256(args.font.read_bytes()).hexdigest(), 'glyphCount': len(chars), 'profiles': []}
    for width in WIDTHS:
        design_width = 280 if width == 280 else 260
        inset = int(4*width/design_width+0.5)
        size = SIZES[width]
        font = ImageFont.truetype(str(args.font), size)
        if hasattr(font, 'set_variation_by_axes'):
            try:
                axes = font.get_variation_axes()
                font.set_variation_by_axes([400 if axis['name'] == b'Weight' else axis['default'] for axis in axes])
            except OSError:
                pass
        line_height = size + 1
        glyphs = []
        for char in chars:
            left, top, right, bottom = font.getbbox(char)
            w, h = max(1, right-left), max(1, bottom-top)
            mask = Image.new('L', (w, h))
            ImageDraw.Draw(mask).text((-left, -top), char, fill=255, font=font)
            if width <= 280:
                mask = mask.point(lambda pixel: 255 if pixel >= 110 else 0)
            glyphs.append((char, mask, round(font.getlength(char)), left, max(0, (line_height-h)//2)))
        atlas_width = 256 if width <= 280 else 512
        positions, x, y, row_height = [], 0, 0, 0
        for char, mask, advance, xoffset, yoffset in glyphs:
            if x + mask.width + 1 > atlas_width:
                x, y, row_height = 0, y + row_height + 1, 0
            positions.append((x, y))
            x += mask.width + 1
            row_height = max(row_height, mask.height)
        atlas = Image.new('RGBA', (atlas_width, y + row_height + 1), (255, 255, 255, 0))
        lines = [f'info face="MAX2 Chinese Labels" size={size} bold=0 italic=0 unicode=1 smooth=1 aa=1',
                 f'common lineHeight={line_height} base={line_height} scaleW={atlas.width} scaleH={atlas.height} pages=1 packed=0',
                 'page id=0 file="FieldLabelChinese.png"', f'chars count={len(glyphs)}']
        advances = {}
        for (char, mask, advance, xoffset, yoffset), (x, y) in zip(glyphs, positions):
            tile = Image.new('RGBA', mask.size, (255, 255, 255, 0))
            tile.putalpha(mask)
            atlas.alpha_composite(tile, (x, y))
            lines.append(f'char id={ord(char)} x={x} y={y} width={mask.width} height={mask.height} xoffset={xoffset} yoffset={yoffset} xadvance={advance} page=0 chnl=15')
            advances[char] = advance
        design_width = 280 if width == 280 else 260
        max_width = width//4 - int(8*width/design_width+0.5)
        max_lines = 0
        for field, label in label_map.items():
            words = word_map.get(field, [label])
            for center in (False, True):
                upper_limit = int(width*(0.16 if center else 0.30))-inset
                lower_limit = int(width*(0.30 if center else 0.16))-inset
                if len(words) == 1:
                    rows = words
                    assert sum(advances[c] for c in rows[0]) <= upper_limit
                else:
                    candidates = []
                    for split in range(1, len(words)):
                        upper, lower = ''.join(words[:split]), ''.join(words[split:])
                        uw, lw = sum(advances[c] for c in upper), sum(advances[c] for c in lower)
                        if uw > upper_limit or lw > lower_limit:
                            continue
                        preferred_words = split < len(words)-split if center else split > len(words)-split
                        preferred_width = lw >= uw if center else uw >= lw
                        score = (0 if preferred_words else 1000)+(0 if preferred_width else 100)+abs(uw-lw)
                        candidates.append((score, [upper, lower]))
                    assert candidates, (width, field, center, words)
                    rows = min(candidates, key=lambda item: item[0])[1]
                assert ''.join(rows) == label
                max_lines = max(max_lines, len(rows))
        folder = ROOT / f'resources-field-label-{width}' / 'fonts'
        folder.mkdir(parents=True, exist_ok=True)
        atlas.save(folder / 'FieldLabelChinese.png')
        (folder / 'FieldLabelChinese.fnt').write_text('\n'.join(lines)+'\n', encoding='utf-8')
        (folder / 'fonts.xml').write_text('<fonts>\n    <font id="FieldLabelChinese" filename="FieldLabelChinese.fnt" antialias="'+('false' if width <= 280 else 'true')+'"/>\n</fonts>\n', encoding='utf-8')
        summary['profiles'].append({'width': width, 'size': size, 'lineHeight': line_height, 'maxLines': max_lines, 'atlas': list(atlas.size)})
    (ROOT / 'scripts/field-label-fonts.json').write_text(json.dumps(summary, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(summary, indent=2))


if __name__ == '__main__':
    main()
