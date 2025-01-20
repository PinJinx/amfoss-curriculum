import Link from "next/link";
import Image from "next/image"


import data from "../../../../temp/Flist.json"
import { stringify } from "querystring";



export default async ({params}:{params:{id:string}}) => {
    const fetchData = async (id: string) => {
        let a = data.movies[0];
        data.movies.forEach( Element => {
            if(Element.id.toString() === params.id)
            {
                a = Element;
            }
        });
        return a;
    }
    const a = await fetchData(params.id);
    return(
        <li>
            <ul className="flex justify-evenly gap-5 mr-2 ml-2">
                <li>
                    <Image src={a.posterUrl} alt="poster" width={324} height={480} />
                    <button className="bg-white rounded-md mt-3.5 w-full h-10 items-center justify-center flex">
                        <h1 className="font-extrabold">ADD TO WATCHLIST</h1>
                    </button>
                </li>
                <li className="text-wrap: overflow-scroll">
                    <h1 className="text-5xl text-white font-extrabold">{a.title}</h1>
                    <h2 className="text-2xl text-white">Year : {a.year}</h2>
                    <div className="h-8"/>
                    <h1 className="text-3xl text-white font-bold">GENRE:</h1>
                    <h2 className="text-xl text-white">{a.genres.join(' , ')}</h2>
                    <div className="h-8"/>
                    <h1 className="text-3xl  text-white font-bold">PLOT:</h1>
                    <h2 className="text-l max-w-xl text-white">{a.plot}</h2>
                    <div className="h-8"/>
                    <h1 className="text-3xl font-bold text-white">Director:</h1>
                    <h2 className="text-l text-white">{a.director}</h2>
                    <div className="h-3"/>
                    <h1 className="text-3xl font-bold text-white">Actors:</h1>
                    <h2 className="text-l text-white">{a.actors}</h2>
                    <div className="h-3"/>
                    <h1 className="text-2xl text-white">Runtime: {a.runtime} minutes.</h1>
                </li>
            </ul>
            <Comments/>
        </li>
    );

};



function Comments()
{
    return(
        <div className="bg-white w-full rounded-md mt-5">
            <h1></h1>
            <ul className="flex ">
            <input className="w-full shadow-md h-9"  placeholder="Share your thoughts here.."/>
            <button className="bg-black font-bold shadow-md h-9 w-20 text-white rounded-m">SEND</button>
            </ul>
            <ul>
                <li className="flex items-center">
                    <Image src="/Icon3.png" alt="alt" width={50} height={50} />
                    <h1>Commenter Name - </h1>
                    <h2 className="ml-4">Comment</h2>
                </li>
                <li className="flex items-center">
                    <Image src="/Icon3.png" alt="alt" width={50} height={50} />
                    <h1>Commenter Name - </h1>
                    <h2 className="ml-4">Comment</h2>
                </li>
                <li className="flex items-center">
                    <Image src="/Icon3.png" alt="alt" width={50} height={50} />
                    <h1>Commenter Name - </h1>
                    <h2 className="ml-4">Comment</h2>
                </li>
                <li className="flex items-center">
                    <Image src="/Icon3.png" alt="alt" width={50} height={50} />
                    <h1>Commenter Name - </h1>
                    <h2 className="ml-4">Comment</h2>
                </li>
            </ul>
        </div>
    );

}