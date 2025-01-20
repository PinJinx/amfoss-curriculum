let allStudents = [
    'A',
    'B-',
    1,
    4,
    5,
    2
  ]
  let studentsWhoPass = [];

  for(let i =0;i<6;i++){
    if( allStudents[i] !='C-' || allStudents[i] >= 3){
        studentsWhoPass.push(allStudents[i]);
    }
  }
  console.log(studentsWhoPass);



  for(let i =1;i<20;i+=3){
    console.log(i)
  }


  let iceCreamFlavors = ["Chocolate", "Strawberry", "Vanilla", "Pistachio", "Rocky Road"];
  for (let i = 0; i < iceCreamFlavors.length; i++) {
    console.log(iceCreamFlavors[i]);
  }
  //The forEach() method of Array
  iceCreamFlavors.forEach((element)=>console.log(element));
  //for..of looping
  for(const flavour of iceCreamFlavors){
    console.log(flavour);
  }

  iceCreamFlavors.map((x)=>console.log(x))
