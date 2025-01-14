"use client";
import { useRouter } from "next/navigation";
import React, { useEffect } from "react";
import Image from "next/image"
import { toast } from "react-toastify";

export default function App() {
  const router = useRouter();
  const notify = () => toast.success("See You Again");
  const handleLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("userId");
    router.push("/home");
  };

  useEffect(() => {
    handleLogout();
  }, []);

  return (
    <div className="flex flex-col align-center items-center justify-center h-full text-5xl">
      Good bye
      <Image src="/chandler.jpg" width={512} height={512} alt="RIPMathew" />
      f . r . i . e . n . d . s
    </div>
  );
}
