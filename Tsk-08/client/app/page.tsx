'use client'
import Link from "next/link";
import Image from "next/image";
import { FormEvent,useState,useEffect } from "react";
import { useRouter } from 'next/navigation';




interface User {
  id: number;
  name: string;
  email: string;
}

export default function MainPage() {

  return (
    <div className="w-full h-screen">
      <Header/>
      <div className="h-full w-full flex items-center justify-center">
        <SignInOrUp/>
      </div>
    </div>
  );
}



function SignInOrUp() {
  const router = useRouter();
  const [RegisterError,setregiter] = useState('');
  const [LoginError,setlogin] = useState('');


  async function Validate(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const data= new FormData(event.currentTarget);
    const nwuser={
      'em':data.get('email'),
      'pass':data.get('password')
    }

    const response=await fetch('http://localhost:8080/getuser', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(nwuser),
    })
    const result = await response.json()

    if(response.ok){
      let s='';
      Object.values(result['val']).forEach((element) => {
        if (!Array.isArray(element)) {
          s += element + ',';
        }
      });
      sessionStorage.setItem('user',result['id']+','+s);
      console.log(result);
      sessionStorage.setItem('watchls',result['val']['watchls'].join(','));
      router.push('/movies')
    }
    else{
      setlogin(result['error']);
    }
  }


  async function Register(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    if(data.get('password')!=data.get('repassword')){
      setregiter('Passwords Doesnot match')
      return 'fail'
    }

    const newUser = {
      'em':data.get('email'),
      'pass':data.get('password'),
      'name':data.get('name')
    }
    console.log(newUser);
    const response=await fetch('http://localhost:8080/user', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(newUser),
    })

    const result = await response.json()
    if(response.ok){
      let s='';
      Object.values(result['val']).forEach((element) => {
        if (!Array.isArray(element)) {
          s += element + ',';
        }
      });
      sessionStorage.setItem('user',result['id']+','+s);
      console.log(result);
      sessionStorage.setItem('watchls',result['val']['watchls'].join(','));
      router.push('/movies')
    }
    else{setregiter(result['error'])}
  }




  return (
    <div>
      <div className="w-[55rem] h-[35rem] bg-white rounded shadow-lg ph:hidden flex items-center justify-center">
        <ul className="flex justify-center">
          <form className="flex w-full h-full flex-col items-center" onSubmit={Validate} >
            <h1 className="font-bold text-4xl mt-5 mb-5">Login</h1>
            <h1 className="text-red-800 mb-5" >{LoginError}</h1>
            <input type="email" name="email" placeholder="  Enter Email" className="bg-white shadow-md rounded border w-[14rem] h-10 mb-4" />
            <input type="password" name="password" placeholder="  Enter Password" className="bg-white shadow-md rounded border w-[14rem] h-10 mb-[134px]" />
            <button type="submit" className="bg-cyan-800 text-white font-bold shadow-md w-20 rounded h-10 mt-4" >SignIn</button>
          </form>


          <div className="bg-cyan-950 w-2 mr-[5rem] ml-[5rem]"/>
          <form className="flex w-full h-full flex-col items-center" onSubmit={Register} >
            <h1 className="font-bold text-4xl mt-5 mb-5">Register</h1>
            <h1 className="text-red-800 mb-5" >{RegisterError}</h1>
            <input type="email" name="email" placeholder="  Enter Email" className="bg-white shadow-md rounded border w-[14rem] h-10 mb-4" />
            <input type="text" name="name" placeholder="  Enter Username" className="bg-white shadow-md rounded border w-[14rem] h-10 mb-4" />
            <input type="password" name="password" placeholder="  Enter Password" className="bg-white shadow-md rounded border w-[14rem] h-10 mb-4" />
            <input type="password" name="repassword" placeholder="  Re-enter Password" className="bg-white shadow-md rounded border w-[14rem] h-10 mb-[3rem]" />
            <button type="submit" className="bg-cyan-800 text-white font-bold shadow-md w-20 rounded h-10 mb-4" >SignUp</button>
          </form>
        </ul>
      </div>


      {/* Phone Display */}
      <div className="w-[20rem] h-[20rem] bg-white rounded shadow-lg ds:hidden">
        <form className="flex w-full h-full flex-col items-center" onSubmit={Validate}  >
          <h1 className="font-bold text-4xl mt-5 mb-5">SignIn</h1>
          <h1 className="text-red-800 mb-5" >{LoginError}</h1>
          <input type="email" name="email" placeholder="  Enter Email" className="bg-white shadow-md rounded border w-[14rem] h-10 mb-4" />
          <input  type="password" name="password" placeholder="  Enter Password" className="bg-white shadow-md rounded border w-[14rem] h-10 mb-4" />
          <button type="submit" className="bg-cyan-800 text-white font-bold shadow-md w-20 rounded h-10 mb-4" >SignIn</button>
          <Link href="/signup"><h1>or Create a new account</h1></Link>
        </form>
      </div>
    </div>
  );
}





function Header(){
  return(
    <div>
      {/* Desktop Display */}
      <li className="fixed flex-col top-0 items-center text-white w-full p-4 flex justify-center z-50 ph:hidden">
        <ul className="flex items-center gap-2">
          <Image src="/Logo2.png" alt="Logo" width={100} height={100} />
          <h1 className="font-bold text-8xl pt-1" >LetterBoxD</h1>
        </ul>
        <h2 className="font-bold text-2xl pt-1" >Track,  Save & Share Films </h2>
    </li>
    {/* Phone Display */}
    <li className="ds:hidden">
      <ul className="items-center gap-2 fixed top-0 shadow-lg bg-slate-100 text-black w-full p-4 flex z-50 justify-center" >
        <Image src="/Logo.png" alt="Logo" width={50} height={50} />
        <h1 className="font-bold text-5xl pt-1" >LetterBoxD</h1>
      </ul>
    </li>
    </div>
  );
}
