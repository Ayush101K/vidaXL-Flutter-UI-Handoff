export const galleries={
 bench:[{src:'bench-2.jpg',label:'Bench with cushions'},{src:'bench-3.jpg',label:'Bench frame view'}],
 chair:[{src:'chair-2.jpg',label:'Set of four chairs'},{src:'chair.jpg',label:'Individual chair view'}],
 sofa:[{src:'sofa-2.jpg',label:'Angled product view'},{src:'sofa-3.jpg',label:'Front view'}],
 curtains:[{src:'curtains-2.jpg',label:'Full curtain pair'},{src:'curtains-3.jpg',label:'Fabric and eyelet detail'}]
};
export function galleryFor(id){return galleries[id]??[];}
export function boundedIndex(index,length){return Math.max(0,Math.min(length-1,Number.isFinite(index)?Math.round(index):0));}
export function boundedZoom(scale){return Math.max(1,Math.min(3,scale));}
