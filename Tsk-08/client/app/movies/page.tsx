'use client'
import Link from "next/link";
import Image from "next/image"
import { JSX } from "react";
import { useState,useEffect } from "react";
export default function MainPage(){
  return(
    <div className="sm:justify-center w-full">
      <Content/>
    </div>
  );
}



interface Movie {
  id: number;
  posterUrl: string;
  title: string;
  year: string;
  rating: string;
}




function Content() {
  const [fcontents, setContent] = useState<JSX.Element[]>([]);
  const [sortedByRating, setSortedByRating] = useState<JSX.Element[]>([]);
  const [sortedByYear, setSortedByYear] = useState<JSX.Element[]>([]);
  useEffect(() => {
    fetch('http://localhost:8080/movies')
      .then((response) => response.json())
      .then((data) => {
        const movies = data.movies as Movie[];
        // Create content components
        const contents = movies.map((element) => (
          <ContentBox
            key={element.id}
            id={element.id.toString()}
            src={element.posterUrl}
            title={element.title}
            rating={element.rating}
            dk={element.year}
          />
        ));
        setContent(contents);
        // Sort movies directly, then map to components
        let ratingSortedMovies = [...movies].sort((a, b) => parseFloat(b.rating) - parseFloat(a.rating));
        let yearSortedMovies = [...movies].sort((a, b) => parseInt(b.year) - parseInt(a.year));
        let ratingSortedContents = ratingSortedMovies.map((element) => (
          <ContentBox
            key={element.id}
            id={element.id.toString()}
            src={element.posterUrl}
            title={element.title}
            rating={element.rating}
            dk={element.year}
          />
        ));
        let yearSortedContents = yearSortedMovies.map((element) => (
          <ContentBox
            key={element.id}
            id={element.id.toString()}
            src={element.posterUrl}
            title={element.title}
            rating={element.rating}
            dk={element.year}
          />
        ));
        ratingSortedContents = ratingSortedContents.slice(0,10)
        yearSortedContents = yearSortedContents.slice(0,10)
        setSortedByRating(ratingSortedContents);
        setSortedByYear(yearSortedContents);
      });
  }, []);
  return (
    <div>
      <h1 className="shadowed text-white font-extrabold text-5xl mb-4">TOP 10 MOVIES</h1>
      <ul className="h-[540px] gap-4  hover:bg-black hover:bg-opacity-10 flex overflow-x-auto justify-start items-center sm:gap-4 md:gap-8 w-full mb-9 max-w-full mr-2">
        {sortedByRating}
      </ul>

      <h1 className="shadowed text-white font-extrabold text-5xl mb-4">LATEST MOVIES</h1>
      <ul className="h-[540px] gap-4  hover:bg-black hover:bg-opacity-10  flex overflow-x-auto justify-start items-center sm:gap-4 md:gap-8 w-full mb-9 max-w-full mr-2">
        {sortedByYear}
      </ul>

      <h1 className="shadowed text-white font-extrabold text-5xl mb-4">ALL MOVIES</h1>
      <ul className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-16 justify-center place-items-center sm:gap-4 md:gap-8">
        {fcontents}
      </ul>

    </div>
  );
}

function ContentBox(props: {src:string;title:string;rating:string;dk:string;id:string;}) {
  let a = "/movies/item/"+props.id;
  return (
    <div className="relative sm:justify-around w-[324px] h-[480px] rounded-sm flex-shrink-0">
      <Link href={a}>
        <Image src={props.src} alt="alt" width={324} height={480} className="object-cover" />
        <div className="absolute inset-0 flex flex-col items-center justify-center text-white bg-black bg-opacity-50 opacity-0 hover:opacity-100">
          <h1 className="text-xl font-bold">{props.title}</h1>
          <ul className="mt-2 space-y-1">
            <h2 className="ml-5">{props.dk}</h2>
            <li className="flex items-center space-x-1">
              <Image src="/star.png" alt="alt" width={30} height={30} />
              <h2>{props.rating}</h2>
            </li>
          </ul>
        </div>
      </Link>
    </div>
  );
}
