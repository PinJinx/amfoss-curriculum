
let candy = ['jellybeans'];
function displayCandy(){
	function addCandy(candyType) {
		candy.push(candyType)
	}
	addCandy('gumdrops');
}
displayCandy();
console.log(candy)




function dragElement(terrariumElement) {
	//set 4 positions for positioning on the screen
	let pos1 = 0,
		pos2 = 0,
		pos3 = 0,
		pos4 = 0;
	terrariumElement.onpointerdown = pointerDrag;

	document.addEventListener("dblclick", (event) => {
		if (event.target === terrariumElement) {
				function move(){
					let rect = terrariumElement.getBoundingClientRect();
					
					if(rect.top<480 && 500<rect.right&&rect.right<1450){
						terrariumElement.style.top = terrariumElement.offsetTop + 3 + 'px';
						requestAnimationFrame(move);
					}
				}
				move();
			}
	});
	
	function pointerDrag(e) {
	    e.preventDefault();
	    console.log(e);
	    pos3 = e.clientX;
	    pos4 = e.clientY;
	    document.onpointermove = elementDrag;
        document.onpointerup = stopElementDrag;
    }
    function elementDrag(e) {
	    pos1 = pos3 - e.clientX;
	    pos2 = pos4 - e.clientY;
	    pos3 = e.clientX;
	    pos4 = e.clientY;
	    terrariumElement.style.top = terrariumElement.offsetTop - pos2 + 'px';
	    terrariumElement.style.left = terrariumElement.offsetLeft - pos1 + 'px';
    }
    function stopElementDrag() {
	    document.onpointerup = null;
	    document.onpointermove = null;
    }
}



dragElement(document.getElementById('plant1'));
dragElement(document.getElementById('plant2'));
dragElement(document.getElementById('plant3'));
dragElement(document.getElementById('plant4'));
dragElement(document.getElementById('plant5'));
dragElement(document.getElementById('plant6'));
dragElement(document.getElementById('plant7'));
dragElement(document.getElementById('plant8'));
dragElement(document.getElementById('plant9'));
dragElement(document.getElementById('plant10'));
dragElement(document.getElementById('plant11'));
dragElement(document.getElementById('plant12'));
dragElement(document.getElementById('plant13'));
dragElement(document.getElementById('plant14'));
