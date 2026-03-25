import os
import sys
import pathlib
import shutil
import subprocess
from pathlib import Path
from colorama import just_fix_windows_console, Fore, Back, Style
just_fix_windows_console()

pathToSpriggit = os.getenv("SPRIGGIT_CLI_PATH")
pathToSkyrim = os.getenv("SKYRIM_SE_PATH")

def hasSpriggit(pathToCheck):
    if pathToCheck.is_file():
        return False
    for fsElement in pathToCheck.iterdir():
        if fsElement.name == 'spriggit-meta.json':
            return True


def scanForCandidate(pathToScan = '.'):
    for fsElement in pathToScan.iterdir():
        if (fsElement.is_dir() and hasSpriggit(fsElement)) or fsElement.name == 'SKSE' or fsElement.name == 'source':
            return True

path = Path('.')
candidatePackages = []
buildExists = False
for fsElement in path.iterdir():
    if fsElement.is_dir():
        if fsElement.name == 'build':
            buildExists = True
        if scanForCandidate(fsElement):
            candidatePackages.append(fsElement.name)
        
if len(candidatePackages) < 1:
    sys.exit('No build candidates found')

print('Found', len(candidatePackages), 'candidate patches for building' )
for package in candidatePackages:
    print(Fore.CYAN + package + Style.RESET_ALL)

if buildExists:
    print(f'{Fore.YELLOW}A \'build\' directory already exists. Proceeding will remove it and it\'s contents{Style.RESET_ALL}')

proceed = False
print(f'{Style.BRIGHT}Proceed with build?{Style.RESET_ALL} [{Fore.GREEN}Y{Style.RESET_ALL}/{Fore.RED}N{Style.RESET_ALL}]')
while not proceed:
    whatDoYouSay = input()
    if whatDoYouSay.lower() == 'y':
        proceed = True
    elif whatDoYouSay.lower() == 'n':
        sys.exit(f'{Back.RED + Fore.BLACK}Aborting{Style.RESET_ALL}')
    else:
        print(f'{Style.BRIGHT}Proceed?{Style.RESET_ALL} [{Fore.GREEN}Y{Style.RESET_ALL}/{Fore.RED}N{Style.RESET_ALL}]')

if buildExists:
    try:
        shutil.rmtree('build')
    except OSError as e:
        print('Unable to remove build directory.', e.strerror)
        sys.exit(-1)

os.mkdir('build')


for candidate in candidatePackages:
    print(f'{Fore.CYAN}========== Building {candidate} =========={Style.RESET_ALL}')
    print(f'\n{Style.BRIGHT} Copying loose files...{Style.RESET_ALL}\n')
    topLevelDir = Path(candidate)
    numOfFiles = 0
    numOfDirectories = 0
    spriggitTargets = []
    filesToCopy = []
    for inner in topLevelDir.iterdir():
        if not hasSpriggit(inner):
            filesToCopy.append(inner)
        else:
            spriggitTargets.append(inner)
    os.mkdir('build/' + candidate)
    for file in filesToCopy:
        if file.is_dir():
            numOfDirectories = numOfDirectories + 1
            shutil.copytree(file, 'build/' + candidate + '/' + file.name, dirs_exist_ok=True)
        else:
            numOfFiles = numOfFiles + 1
            shutil.copy(file, 'build/' + candidate)

    print(f'{Fore.BLUE + Back.GREEN + ' Build dir created. ' + str(numOfFiles) + Fore.BLACK} loose files and {Fore.BLUE + str(numOfDirectories) + Fore.BLACK} directories copied successfuly {Style.RESET_ALL}\n')
    print(f'{Style.BRIGHT} Building plugins...{Style.RESET_ALL}\n')

    for plugin in spriggitTargets:
        outputPath = Path('./build/'+ candidate + '/' + plugin.name + '.esp')
        inputPath = Path('./' + candidate + '/' + plugin.name)
        try:
            subprocess.run([pathToSpriggit,'deserialize','-i',inputPath,'-o',outputPath], capture_output=True, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print('Deserialization failed.', e.cmd, e.output)
            sys.exit(-1)
        print(f' {Fore.GREEN + plugin.name + '.esp'} built successfully{Style.RESET_ALL}\n')
    
    if len(spriggitTargets) > 0:
        print(f'{Back.GREEN + Fore.BLACK} All plugins for {Fore.BLUE + candidate + Fore.BLACK} built successfully {Style.RESET_ALL}\n')
    else:
        print(f'\n{Fore.YELLOW} No plugins to build\n')

    print(f' {Style.BRIGHT}Compiling scripts...{Style.RESET_ALL}')
    
    compilerPath = Path(pathToSkyrim + '/Papyrus Compiler/PapyrusCompiler.exe')
    compilerOutput = Path(f'./build/{candidate}/scripts/')
    compilerImport = ''
    numOfScripts = 0

    for lv1 in topLevelDir.iterdir():
        if lv1.name.lower() == 'source':
            compilerSource = Path(str(lv1) + '\\Scripts')
            if compilerSource.exists():
                break
        elif lv1.name.lower() == 'scripts':
            compilerSource = Path(str(lv1) + '\\Source')
            if compilerSource.exists():
                break
    if 'compilerSource' in locals() and compilerSource.exists():
        papyrusIncludes = []
        papyrusIncludes.append(Path(compilerSource))
        papyrusIncludes.append(Path('./include only scripts'))
        papyrusIncludes.append(Path(pathToSkyrim + '/data/scripts/source'))
        papyrusIncludes.append(Path(pathToSkyrim + '/data/source/scripts'))
        #Feel free to add your own Papyrus include directories. Don't leave a trailing /
        for include in papyrusIncludes:
            compilerImport = compilerImport + str(include) + ';'
        if not compilerOutput.exists():
            os.mkdir(compilerOutput)
        for file in compilerSource.iterdir():
            if file.is_file() and file.suffix == '.psc':
                print(f'{Fore.MAGENTA} Compiling {file.name}...{Style.RESET_ALL}')
                try:
                    subprocess.run([compilerPath,file,'-op',f'-i={compilerImport}',f'-o={compilerOutput}','-f=TESV_Papyrus_Flags.flg'], capture_output=True, shell=True, check=True)
                    print(f' {Fore.GREEN + file.name} compiled successfully{Style.RESET_ALL}')
                    numOfScripts = numOfScripts + 1
                except subprocess.CalledProcessError as e:
                    print(f'{Back.RED + Fore.BLACK} FALIED TO COMPILE SCRIPTS {Style.RESET_ALL}')
                    print(e.cmd)
                    print(e.stdout.decode('ascii'))
                    print(e.stderr.decode('ascii'))
                    sys.exit(-1)
        print(f'\n{Back.GREEN + Fore.BLACK} All {Fore.BLUE + str(numOfScripts) + Fore.BLACK} scripts compiled successfully. {Style.RESET_ALL}\n')
    else:
        print(f'\n{Fore.YELLOW} Nothing to compile\n')

    print(f' {Style.BRIGHT}Creating archive...{Style.RESET_ALL}\n')
    shutil.make_archive(Path(f'./build/{candidate}'), 'zip', Path(f'./build/{candidate}'))
    print(f'{Back.GREEN} {Fore.BLUE + candidate + '.zip' + Fore.BLACK} archive created successfully. {Style.RESET_ALL}\n')
    shutil.rmtree(Path(f'./build/{candidate}/'))

print(f'\n{Back.GREEN}                                     {Style.RESET_ALL}')
print(f'{Back.GREEN + Fore.BLACK}          Build Successful           {Style.RESET_ALL}')
print(f'{Back.GREEN}                                     {Style.RESET_ALL}')