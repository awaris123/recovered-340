{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_cs495 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/aakef/Documents/Haskell_WS/CS-340/cs340/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/bin"
libdir     = "/home/aakef/Documents/Haskell_WS/CS-340/cs340/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/lib/x86_64-linux-ghc-8.4.4/cs495-0.1.0.0-KutlSdU7wHp4JRPmmlseFE-main"
dynlibdir  = "/home/aakef/Documents/Haskell_WS/CS-340/cs340/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/lib/x86_64-linux-ghc-8.4.4"
datadir    = "/home/aakef/Documents/Haskell_WS/CS-340/cs340/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/share/x86_64-linux-ghc-8.4.4/cs495-0.1.0.0"
libexecdir = "/home/aakef/Documents/Haskell_WS/CS-340/cs340/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/libexec/x86_64-linux-ghc-8.4.4/cs495-0.1.0.0"
sysconfdir = "/home/aakef/Documents/Haskell_WS/CS-340/cs340/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "cs495_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "cs495_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "cs495_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "cs495_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "cs495_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "cs495_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
