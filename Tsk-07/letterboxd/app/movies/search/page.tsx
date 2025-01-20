'use client'
import Link from "next/link";
import Image from "next/image";
import data from '../../../temp/Flist.json';
import { JSX, useState } from "react";




export default function MainPage() {
    const [searchquery,setsearchquery]=useState<string>("");
    const [selectedGenres, setSelectedGenres] = useState<string[]>([]);


    const SetQuery=(query:string)=>{
        setsearchquery(query);
    }
    const GenreClicked = (genre:string) =>{
        setSelectedGenres(prev =>
            prev.includes(genre) ? prev.filter(g => g !== genre) : [...prev, genre]
        );
    };
    console.log(selectedGenres);

    return (
        <div className="sm:justify-center w-full h-full">
            <SearchBar selectedGenres={selectedGenres} GenreClicked={GenreClicked} SetQuery={SetQuery} />
            <br className="h-6"/>
            <Content selectedGenres={selectedGenres} selectedQuery={searchquery}/>
        </div>
    );
}



function SearchBar({ selectedGenres, GenreClicked ,SetQuery}: { selectedGenres: string[], GenreClicked: (genre: string) => void ,SetQuery: (query: string) => void }) {
    const contents: JSX.Element[] = [];
    data.genres.forEach(element => {
        contents.push(
            <button className={` rounded-md w-20 ${selectedGenres.includes(element) ? 'bg-cyan-800 text-white' : 'bg-white text-black'}`} key={element} onClick={()=>GenreClicked(element)}>
                <h1>{element}</h1>
            </button>
        );
    });
    const val='';
    return (
        <div>
            <input placeholder="Search by Name..." className="bg-white rounded-sm w-full h-9 mb-3"  onChange={(e)=>SetQuery(e.target.value)}/>
            <li className="flex flex-wrap gap-3">
                {contents}
            </li>
        </div>
    );
}

function Content({ selectedGenres,selectedQuery}: { selectedGenres: string[], selectedQuery:string}) {
    const contents:JSX.Element[] = [];
    let keys:[number]=[-9];


    data.movies.forEach((element) => {
        for (let i = 0; i < element.genres.length; i++) {
            if (selectedGenres.includes(element.genres[i]) && !keys.includes(element.id) || element.title.toLowerCase().match(selectedQuery.toLowerCase())  && !keys.includes(element.id)&& selectedQuery!="") {
                contents.push(
                    <ContentBox
                        key={element.id}
                        id={element.id.toString()}
                        src={element.posterUrl}
                        title={element.title}
                        lk={element.year}
                        dk={element.year}
                    />
                );
                keys.push(element.id);
            }
        }
    });
    return (
        <ul className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-16 justify-center place-items-center sm:gap-4 md:gap-8">
            {contents}
        </ul>
    );
}

function ContentBox(props: { src: string; title: string; lk: string; dk: string; id: string; }) {
    let a = "/movie/" + props.id;
    return (
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
