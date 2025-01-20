'use client'
import Image from "next/image"
import { JSX, useEffect, useState, FormEvent } from 'react';
import { useParams } from "next/navigation";
import { hasUncaughtExceptionCaptureCallback } from "process";


interface Movie {
    id: number;
    posterUrl: string;
    title: string;
    year: string;
    comments: string[];
}




export default () => {
    const [a, setMovie] = useState<any>(null);
    const params=useParams<{id:'string'}>();
    const [watchlsb, setwatchlsbutton] =  useState<boolean | undefined>(undefined);;
    async function Watchls(mode:boolean = false) {
        const ls={
            'id': sessionStorage.getItem('user')?.split(',')[0],
            'movie' : parseInt(params.id),
            'search': mode
        }
        const response=await fetch('http://localhost:8080/watchls', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(ls),
        })
        const result = await response.json()
        if(response.ok){
            setwatchlsbutton(result['mode']);
            if(result['mode'] && !mode){
                sessionStorage.setItem('watchls',sessionStorage.getItem('watchls') + ',' + params.id)
                console.log(ls)
            }
            else if(!mode) {
                const currentWatchList = sessionStorage.getItem("watchls") || "";
                sessionStorage.setItem(
                    "watchls",
                    currentWatchList.split(",").filter((id:string) => id !== params.id.toString()).join(",")
                );
                console.log('removed')
            }

            if(!mode){
                {/* Update the server */}
                const list={
                    'id': sessionStorage.getItem('user')?.split(',')[0],
                    'list': sessionStorage.getItem("watchls")
                }
                const lsr=await fetch('http://localhost:8080/setwatchls', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(list),
                })
            }
        }
    }

    useEffect(()=> {
        Watchls(true);
        fetch('http://localhost:8080/movies').then(
            (response) => response.json()
        ).then((data) =>{
            (data['movies'] as Movie[]).forEach(element => {
                if(element.id == parseInt(params.id)){
                    setMovie(element);
                }
            });
        } )
    },[])

    {/* a here is the movie*/}
    if (!a) {
        return <div>Loading...</div>;
    }
    return(
        <li>
            <ul className="flex justify-evenly gap-5 mr-2 ml-2">
                <li>
                    <Image src={a.posterUrl} alt="poster" width={324} height={480} />
                    <button onClick={()=>Watchls(false)} className={`rounded-md mt-3.5 w-full h-10 items-center justify-center flex ${watchlsb ? 'bg-red-400 text-white' : 'bg-white text-black' }  `}>
                        <h1 className='font-extrabold '>
                            {watchlsb ? 'REMOVE FROM WATCHLIST':'ADD TO WATCHLIST'}
                        </h1>
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
            <ul className="flex">
            <Rating total={a.noofrating} brating={a.rating} />
            <Comments comments={a.comments} id={params.id} />
            </ul>
        </li>
    );

};

function Rating({total,brating}:{total:string,brating:string}){
    const [stars,setstars]=useState([false,false,false,false,false])
    const [final_rating,setrating] = useState(brating);
    function starclicked(index:number){
        let l=[]
        for(let i=0;i<stars.length;i++){
            if(index==0 && i==0){l.push(!stars[0])}
            else if(i<=index){l.push(true)}
            else{l.push(false)}
        }
        setstars(l)
    }
    useEffect(()=>{
        let a =0;
        stars.forEach((ele)=>{ele?a+=1:a+=0})
        const newRating = ((parseFloat(brating.replace('/5', '')) * parseInt(total)) + a) /(parseInt(total) + 1);
        setrating(newRating.toFixed(1) + '/5');
    })
    return(
        <div className="w-[70%] h-[15rem] flex flex-col items-center mt-7">
            <h1 className="text-white font-bold text-3xl mb-7">  Movie Rating:   {final_rating}</h1>
            <ul className="flex gap-5 mb-8">
                <Image className="hover:shadow-md" src={stars[0]?'/star.png':'/star2.png'} alt="rating" width={100} height={100} onClick={()=>starclicked(0)}/>
                <Image className="hover:shadow-md" src={stars[1]?'/star.png':'/star2.png'} alt="rating" width={100} height={100} onClick={()=>starclicked(1)}/>
                <Image className="hover:shadow-md" src={stars[2]?'/star.png':'/star2.png'} alt="rating" width={100} height={100} onClick={()=>starclicked(2)}/>
                <Image className="hover:shadow-md" src={stars[3]?'/star.png':'/star2.png'} alt="rating" width={100} height={100} onClick={()=>starclicked(3)}/>
                <Image className="hover:shadow-md" src={stars[4]?'/star.png':'/star2.png'} alt="rating" width={100} height={100} onClick={()=>starclicked(4)}/>
            </ul>
        </div>
    );
}

function Comments({comments,id}:{comments:Array<String>; id:string})
{
    const [comm,setcomm] = useState<JSX.Element[]>([]);
    useEffect(
        ()=>{
            if(comments.length == 0)
            {
                setcomm([<h1 key='1' className="text-black font-bold text-xl flex w-[100%] justify-center">No Comments Yet</h1>]);
            }
            else
            {
                let temp = []
                for(let i = 0;i < comments.length;i++){
                    let k = comments[i].split('@$');
                    temp.push(
                    <li className="flex items-center" key={k[0]+k[1]}>
                        <Image src="/Icon3.png" alt="alt" width={50} height={50} />
                        <h1 className="text-black font-bold text-xl">{k[0]}:</h1>
                        <h2 className="ml-4">{k[1]}</h2>
                    </li>
                    );
                }
                setcomm(temp);
            }
        }
    ,[comments])

    async function AddComm(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        const data = new FormData(event.currentTarget);
        const commentText = (data.get('data') as string) || 'Comment Not Found';
        const username = sessionStorage.getItem('user')?.split(',')[2] || 'Unknown User';
        const newComment = (
            <li className="flex items-center" key={`${username}-${commentText}`}>
                <Image src="/Icon3.png" alt="User Icon" width={50} height={50} />
                <h1 className="text-black font-bold text-xl">{username}:</h1>
                <h2 className="ml-4">{commentText}</h2>
            </li>
        );

        event.currentTarget.reset();

        const nwcomm={
            'movie':id,
            'comm':username+'@$'+commentText
        }
        console.log(nwcomm);
        const response=await fetch('http://localhost:8080/comm', {
            method: 'POST',
            headers: {
            'Content-Type': 'application/json',
            },
            body: JSON.stringify(nwcomm),
        })
        const result = await response.json()

        if(response.ok){
            if(comments.length > 0){
                setcomm((prevComm) => [...prevComm, newComment]);
            }
            else{setcomm([newComment]);}
        }
        else{
            console.log(result);
        }
    }
    return(
        <div className="bg-white w-full rounded-md mt-5">
            <h1></h1>
            <ul>
                <form onSubmit={AddComm} className="flex">
                    <input name='data' className="w-full shadow-md h-9"  placeholder="Share your thoughts here.."/>
                    <button type="submit" className="bg-black font-bold shadow-md h-9 w-20 text-white rounded-m">SEND</button>
                </form>
            </ul>
            <ul>
                {comm}
            </ul>
        </div>
    );

}