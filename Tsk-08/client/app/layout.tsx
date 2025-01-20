import type { Metadata } from "next";
import './globals.css';
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
    <html>
      <body>
        {children}
      </body>
    </html>
  );
}
