'use client'
import type { Metadata } from "next";
import '../globals.css';
import Link from "next/link";
import Image from "next/image";
import { FormEvent, useEffect, useState } from "react";
import { Input } from "postcss";
import JSXStyle from "styled-jsx/style";
import { useRouter } from "next/navigation";


export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return(
    <ul>
      <div className="pt-36">
        <Header></Header>
        {children}
      </div>

    </ul>

  );
}


function Header(){

  const [settings,setsetting]=useState(false)
  const [bt,setbutton]=useState(false)
  const router = useRouter();
  const [userinfo, setUserInfo] = useState(['Error', 'Error', 'Error', 'Error']);
  const user = sessionStorage.getItem('user');
  useEffect(() => {
    const user = sessionStorage.getItem('user');
    if (user) {
      setUserInfo(user.split(','));
    } else {
      router.push('/');
    }
  }, [router]);

  function ToggleButton(){
    setsetting(!settings)
  }
  async function Apply(event: FormEvent<HTMLFormElement>){
    event.preventDefault()
    const data = new FormData(event.currentTarget);
    const ls={
      'id':userinfo[0],
      'em':data.get('email'),
      'name':data.get('name'),
      'pass':data.get('pass')
    }
    console.log(ls)
    const response = await fetch('http://localhost:8080/upduser',{
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(ls),
    })
    const result = await response.json()
    if(response.ok){
      sessionStorage.setItem('user',Object.values(ls).join(','))
      setbutton(true)
    }
    console.log(result)
  }
  return(
    <div>
      {/* Desktop Display */}
      {/* Setting SideBar */}
      <form className={`fixed right-0 h-full top-0 bg-white z-50 w-[30%] rounded-xl shadow-2xl flex-col flex ph:hidden ${settings ? 'visible' : 'hidden'}`} onSubmit={Apply}>
        <button onClick={ToggleButton} className="ml-3 mt-3 w-[50px] h-[50px]">
          <Image src="/Icon1.png" alt="Back Icon" width={50} height={50} />
          <h2 className="text-sm mt-1 group-hover:font-bold">Back</h2>
        </button>
        <div className="w-full flex items-center justify-center">
          <h1 className="mt-16 font-extrabold text-3xl mb-16">ACCOUNT SETTINGS</h1>
        </div>
        <h1 className="font-extrabold text-xl mb-3 ml-3 text-cyan-800 underline">USERNAME</h1>
        <div className="w-full flex flex-col items-center mb-8">
          <input placeholder="Enter UserName" onChange={()=>setbutton(false)} name="name" defaultValue={userinfo[2]} className="rounded shadow-md border-spacing-4 border w-[90%] h-12 text-xl"></input>
        </div>
        <h1 className="font-extrabold text-xl mb-3 ml-3 text-cyan-800 underline mt-6">PASSWORD</h1>
        <div className="w-full flex flex-col items-center mb-8">
        <input placeholder="Enter Email" type="password" name="pass"  onChange={()=>setbutton(false)}  defaultValue={userinfo[3]} className="rounded shadow-md border-spacing-4 border w-[90%] h-12 text-xl"></input>
        </div>
        <h1 className="font-extrabold text-xl mb-3 ml-3 text-cyan-800 underline mt-6">EMAIL</h1>
        <div className="w-full flex flex-col items-center mb-20">
          <input placeholder="Enter Password" type="email" name="email"  onChange={()=>setbutton(false)}  defaultValue={userinfo[1]} className="rounded shadow-md border-spacing-4 border w-[90%] h-12 text-xl"></input>
        </div>
        <div className="w-full flex flex-col items-center mb-8">
          <button className="bg-cyan-700 text-3xl text-white font-bold rounded-full w-40 shadow-md hover:bg-cyan-950" type="submit">APPLY</button>
        </div>
      </form>


      <li className="fixed top-0 shadow-lg bg-slate-100 text-black w-full p-4 flex justify-between z-30 ph:hidden">
        <ul className="flex items-center gap-2">
          <Image src="/Logo.png" alt="Logo" width={50} height={50} />
          <h1 className="font-bold text-5xl pt-1" >LetterBoxD</h1>
        </ul>
        <ul className="flex justify-evenly gap-7 items-center">
          <li className="h-20 w-20 flex flex-col items-center justify-center group">
            <Link href="/movies/search">
              <Image src="/Icon4.png" alt="Search Icon" width={50} height={50} />
              <h2 className="text-sm mt-1 group-hover:font-bold">Search</h2>
            </Link>
          </li>
          <li className="h-20 w-20 flex flex-col items-center justify-center group">
            <Link href="/movies">
              <Image src="/Icon3.png" alt="Films Icon" width={50} height={50} />
              <h2 className="text-sm mt-1 group-hover:font-bold">Films</h2>
            </Link>
          </li>
          <li className="h-20 w-20 flex flex-col items-center justify-center group">
            <Link href="/movies/watchls">
              <Image src="/Icon2.png" alt="Watch List Icon" width={50} height={50} />
              <h2 className="text-sm mt-1 group-hover:font-bold">Watch List</h2>
            </Link>
          </li>
          <li className="h-20 w-20 flex flex-col items-center justify-center group">
            <button onClick={ToggleButton}>
              <Image src="/Icon1.png" alt="Settings Icon" width={50} height={50} />
              <h2 className="text-sm mt-1 group-hover:font-bold">Settings</h2>
            </button>
          </li>
        </ul>
    </li>
    {/* Phone Display */}
    <li className="ds:hidden">
      <ul className="items-center gap-2 fixed top-0 shadow-lg bg-slate-100 text-black w-full p-4 flex z-50 justify-center" >
        <Image src="/Logo.png" alt="Logo" width={50} height={50} />
        <h1 className="font-bold text-5xl pt-1" >LetterBoxD</h1>
      </ul>
      <ul className="flex justify-evenly gap-7 items-center fixed bottom-0 shadow-lg bg-slate-100 text-black w-full p-4 z-50">
        <li className="h-20 w-20 flex flex-col items-center justify-center group">
          <Link href="/search">
            <Image src="/Icon4.png" alt="Search Icon" width={50} height={50} />
            <h2 className="text-sm mt-1 group-hover:font-bold">Search</h2>
          </Link>
        </li>
        <li className="h-20 w-20 flex flex-col items-center justify-center group">
          <Link href="/movies">
            <Image src="/Icon3.png" alt="Films Icon" width={50} height={50} />
            <h2 className="text-sm mt-1 group-hover:font-bold">Films</h2>
          </Link>
        </li>
        <li className="h-20 w-20 flex flex-col items-center justify-center group">
          <Link href="/movies/watchls">
            <Image src="/Icon2.png" alt="Watch List Icon" width={50} height={50} />
            <h2 className="text-sm mt-1 group-hover:font-bold">Watch List</h2>
          </Link>
        </li>
        <li className="h-20 w-20 flex flex-col items-center justify-center group">
          <Link href="/movies/setting">
            <Image src="/Icon1.png" alt="Settings Icon" width={50} height={50} />
            <h2 className="text-sm mt-1 group-hover:font-bold">Settings</h2>
          </Link>
        </li>
      </ul>
    </li>
    </div>
  );
}
