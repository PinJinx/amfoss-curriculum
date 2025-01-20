import type { Metadata } from "next";
import '../globals.css';
import Link from "next/link";
import Image from "next/image";


export const metadata: Metadata = {
  title: "LetterBoxd",
  description: "Track,Save,Share Films!",
};

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
  return(
    <div>
      {/* Desktop Display */}
      <li className="fixed top-0 shadow-lg bg-slate-100 text-black w-full p-4 flex justify-between z-50 ph:hidden">
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
            <Link href="/movies/setting">
              <Image src="/Icon1.png" alt="Settings Icon" width={50} height={50} />
              <h2 className="text-sm mt-1 group-hover:font-bold">Settings</h2>
            </Link>
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
