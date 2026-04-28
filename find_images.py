import json

with open(r'C:\Users\Alctraz\.gemini\antigravity\brain\982f485c-acd3-4708-a916-748a3995536d\figma_out.json', encoding='utf-8') as f:
    d = json.load(f)

for k, v in d.get('nodes', {}).items():
    doc = v.get('document', {})
    
    def find_images(node):
        fills = node.get('fills', [])
        for fill in fills:
            if fill.get('type') == 'IMAGE':
                print(f"Found IMAGE in node {node.get('id')} ({node.get('name')})")
                
        bg = node.get('background', [])
        for b in bg:
            if b.get('type') == 'IMAGE':
                print(f"Found IMAGE background in var {node.get('id')} ({node.get('name')})")
                
        for c in node.get('children', []):
            find_images(c)
            
    if doc.get('type') in ['FRAME', 'SECTION']:
        find_images(doc)
