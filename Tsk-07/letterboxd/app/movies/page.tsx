import Link from "next/link";
import Image from "next/image"


//read file
import data from '../../temp/Flist.json';
import { JSX } from "react";

export default function MainPage(){
  return(
    <div className="sm:justify-center w-full">
      <Content/>
    </div>
  );
}






function Content() {
  const contents:JSX.Element[] = [];
  let a = 1;
  data.movies.forEach((element) => {
    contents.push(
      <ContentBox
        key={element.id}
        id = {element.id.toString()}
        src={element.posterUrl}
        title={element.title}
        lk={element.year}
        dk={element.year}
      />
    );
    a++;
  });



  return (
  <ul className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-16 justify-center place-items-center sm:gap-4 md:gap-8">
    {contents}
  </ul>
  );
}



function ContentBox(props: {src:string;title:string;lk:string;dk:string;id:string;}){
  let a = "/movies/item/"+props.id;
  return(
    <div className="relative sm:justify-around w-[324px] h-[480px] rounded-sm">
      <Link href={a}>
        <Image src={props.src} alt="alt" width={324} height={480} className="object-cover" />
        <div className="absolute inset-0 flex flex-col items-center justify-center text-white bg-black bg-opacity-50 opacity-0 hover:opacity-100">
          <h1 className="text-xl font-bold">{props.title}</h1>
          <ul className="mt-2 space-y-1">
            <li className="flex items-center space-x-2">
              <Image src="/Logo.png" alt="alt" width={10} height={10} />
              <h2>{props.lk}</h2>
            </li>
            <li className="flex items-center space-x-2">
              <Image src="/Logo.png" alt="alt" width={10} height={10} />
              <h2>{props.dk}</h2>
            </li>
          </ul>
        </div>
      </Link>
    </div>

  );
}





