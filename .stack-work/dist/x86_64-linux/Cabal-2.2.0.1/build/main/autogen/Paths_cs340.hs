{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_cs340 (
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

bindir     = "/home/aakef/Documents/Haskell_WS/CS-340/cs340-spring19-awaris/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/bin"
libdir     = "/home/aakef/Documents/Haskell_WS/CS-340/cs340-spring19-awaris/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/lib/x86_64-linux-ghc-8.4.4/cs340-0.1.0.0-3dS1fVWBgPb9Fq3w4xbeUl-main"
dynlibdir  = "/home/aakef/Documents/Haskell_WS/CS-340/cs340-spring19-awaris/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/lib/x86_64-linux-ghc-8.4.4"
datadir    = "/home/aakef/Documents/Haskell_WS/CS-340/cs340-spring19-awaris/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/share/x86_64-linux-ghc-8.4.4/cs340-0.1.0.0"
libexecdir = "/home/aakef/Documents/Haskell_WS/CS-340/cs340-spring19-awaris/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/libexec/x86_64-linux-ghc-8.4.4/cs340-0.1.0.0"
sysconfdir = "/home/aakef/Documents/Haskell_WS/CS-340/cs340-spring19-awaris/.stack-work/install/x86_64-linux/lts-12.26/8.4.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "cs340_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "cs340_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "cs340_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "cs340_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "cs340_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "cs340_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
