import json

with open(r'C:\Users\Alctraz\.gemini\antigravity\brain\982f485c-acd3-4708-a916-748a3995536d\figma_out.json', encoding='utf-8') as f:
    d = json.load(f)

with open(r'C:\Users\Alctraz\.gemini\antigravity\brain\982f485c-acd3-4708-a916-748a3995536d\figma_summary.txt', 'w', encoding='utf-8') as out:
    def traverse(node, depth):
        name = node.get('name', 'unnamed')
        t = node.get('type', '')
        text = node.get('characters', '').replace('\n', '\\n')
        fills = [f['color'] for f in node.get('fills', []) if f.get('type') == 'SOLID' and 'color' in f]
        colors = [f"#{int(c.get('r',0)*255):02X}{int(c.get('g',0)*255):02X}{int(c.get('b',0)*255):02X}" for c in fills]
        
        # Process backgrounds too, as some frames use background instead of fills
        bg = [f['color'] for f in node.get('background', []) if f.get('type') == 'SOLID' and 'color' in f]
        if bg: colors += [f"BG: #{int(c.get('r',0)*255):02X}{int(c.get('g',0)*255):02X}{int(c.get('b',0)*255):02X}" for c in bg]
        
        bgColor = node.get('backgroundColor')
        if bgColor and bgColor.get('a', 0) > 0:
            colors.append(f"BgC: #{int(bgColor.get('r',0)*255):02X}{int(bgColor.get('g',0)*255):02X}{int(bgColor.get('b',0)*255):02X}")
            
        color_str = ' | Colors: ' + ', '.join(colors) if colors else ''
        text_str = f' | Text: "{text}"' if t == 'TEXT' else ''
        out.write('  '*depth + f'- {t} {name}{color_str}{text_str}\n')
        for c in node.get('children', []):
            traverse(c, depth+1)

    for k, v in d.get('nodes', {}).items():
        doc = v.get('document', {})
        if doc.get('type') in ['FRAME', 'SECTION']:
            traverse(doc, 0)
