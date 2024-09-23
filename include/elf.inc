%ifndef ELF_INC
%define ELF_INC

; Sources used :
;   - In-depth: ELF - The Extensible & Linkable Format : https://www.youtube.com/watch?v=nC1U1LJQL8o
;   - The ELF specification                            : https://refspecs.linuxfoundation.org/elf/elf.pdf
;   - elf.h from the Linux kernel                      : https://elixir.bootlin.com/linux/v6.11/source/include/uapi/linux/elf.h
;   - ELF Header                                       : https://refspecs.linuxfoundation.org/elf/gabi4+/ch4.eheader.html

; ELF types :
;
;   - Elf_Half         : u16
;   - Elf_Word         : u32
;
;   - Elf32_Addr       : u32
;   - Elf32_Off        : u32
;
;   - Elf64_Addr       : u64
;   - Elf64_Off        : u64
;
;   - enum EI_CLASS    : u8
;   - enum EI_DATA     : u8
;   - enum EI_OSABI    : u8
;   - enum ELF_TYPE    : Elf_Half
;   - enum ELF_MACHINE : Elf_Half

%define EI_NIDENT               16                ; Number of bytes in elf header file's identifier

%define ELF_MAGIC_NUMBER        0x7F454C46        ; 0x7F, "ELF"

%define EI_CLASS_NONE           0                 ; Invalid value
%define EI_CLASS_32             1                 ; 32bits elf image
%define EI_CLASS_64             2                 ; 64bits elf image

%define EI_DATA_NONE            0                 ; Invalid value
%define EI_DATA_2LSB            1                 ; 2's complement, little endian
%define EI_DATA_2MSB            2                 ; 2's complement, big endian

%define EI_VERSION_NONE         0                 ; Invalid value
%define EI_VERSION_CURRENT      1                 ; The only currently valid value

%define EI_OSABI_NONE           0                 ; No extensions or unspecified
%define EI_OSABI_HPUX           1                 ; Hewlett-Packard HP-UX
%define EI_OSABI_NETBSD         2                 ; NetBSD
%define EI_OSABI_LINUX          3                 ; Linux
%define EI_OSABI_SOLARIS        6                 ; Sun Solaris
%define EI_OSABI_AIX            7                 ; AIX
%define EI_OSABI_IRIX           8                 ; IRIX
%define EI_OSABI_FREEBSD        9                 ; FreeBSD
%define EI_OSABI_TRU64          10                ; Compaq TRU64 UNIX
%define EI_OSABI_MODESTO        11                ; Novell Modesto
%define EI_OSABI_OPENBSD        12                ; Open BSD
%define EI_OSABI_OPENVMS        13                ; Open VMS
%define EI_OSABI_NSK            14                ; Hewlett-Packard Non-Stop Kernel

%define ELF_TYPE_NONE           0                 ; No file type
%define ELF_TYPE_REL            1                 ; Relocatable file
%define ELF_TYPE_EXEC           2                 ; Executable file
%define ELF_TYPE_DYN            3                 ; Shared object file
%define ELF_TYPE_CORE           4                 ; Core file
%define ELF_TYPE_LOOS           0xfe00            ; Operating system-specific range start
%define ELF_TYPE_HIOS           0xfeff            ; Operating system-specific range end
%define ELF_TYPE_LOPROC         0xff00            ; Processor-specific range start
%define ELF_TYPE_HIPROC         0xffff            ; Processor-specific range end

%define ELF_MACHINE_NONE        0                 ; No machine
%define ELF_MACHINE_M32         1                 ; AT&T WE 32100
%define ELF_MACHINE_SPARC       2                 ; SPARC
%define ELF_MACHINE_386         3                 ; Intel 80386
%define ELF_MACHINE_68K         4                 ; Motorola 68000
%define ELF_MACHINE_88K         5                 ; Motorola 88000
%define ELF_MACHINE_486         6                 ; Deprecated, now reserved for future uses
%define ELF_MACHINE_860         7                 ; Intel 80860
%define ELF_MACHINE_MIPS        8                 ; MIPS I Architecture
%define ELF_MACHINE_S370        9                 ; IBM System/370 Processor
%define ELF_MACHINE_MIPS_RS3_LE 10                ; MIPS RS3000 Little-endian
%define ELF_MACHINE_PARISC      15                ; Hewlett-Packard PA-RISC
%define ELF_MACHINE_VPP500      17                ; Fujitsu VPP500
%define ELF_MACHINE_SPARC32PLUS 18                ; Enhanced instruction set SPARC
%define ELF_MACHINE_960         19                ; Intel 80960
%define ELF_MACHINE_PPC         20                ; PowerPC
%define ELF_MACHINE_PPC64       21                ; 64-bit PowerPC
%define ELF_MACHINE_S390        22                ; IBM System/390 Processor
%define ELF_MACHINE_V800        36                ; NEC V800
%define ELF_MACHINE_FR20        37                ; Fujitsu FR20
%define ELF_MACHINE_RH32        38                ; TRW RH-32
%define ELF_MACHINE_RCE         39                ; Motorola RCE
%define ELF_MACHINE_ARM         40                ; Advanced RISC Machines ARM
%define ELF_MACHINE_ALPHA       41                ; Digital Alpha
%define ELF_MACHINE_SH          42                ; Hitachi SH
%define ELF_MACHINE_SPARCV9     43                ; SPARC Version 9
%define ELF_MACHINE_TRICORE     44                ; Siemens TriCore embedded processor
%define ELF_MACHINE_ARC         45                ; Argonaut RISC Core, Argonaut Technologies Inc.
%define ELF_MACHINE_H8_300      46                ; Hitachi H8/300
%define ELF_MACHINE_H8_300H     47                ; Hitachi H8/300H
%define ELF_MACHINE_H8S         48                ; Hitachi H8S
%define ELF_MACHINE_H8_500      49                ; Hitachi H8/500
%define ELF_MACHINE_IA_64       50                ; Intel IA-64 processor architecture
%define ELF_MACHINE_MIPS_X      51                ; Stanford MIPS-X
%define ELF_MACHINE_COLDFIRE    52                ; Motorola ColdFire
%define ELF_MACHINE_68HC12      53                ; Motorola M68HC12
%define ELF_MACHINE_MMA         54                ; Fujitsu MMA Multimedia Accelerator
%define ELF_MACHINE_PCP         55                ; Siemens PCP
%define ELF_MACHINE_NCPU        56                ; Sony nCPU embedded RISC processor
%define ELF_MACHINE_NDR1        57                ; Denso NDR1 microprocessor
%define ELF_MACHINE_STARCORE    58                ; Motorola Star*Core processor
%define ELF_MACHINE_ME16        59                ; Toyota ME16 processor
%define ELF_MACHINE_ST100       60                ; STMicroelectronics ST100 processor
%define ELF_MACHINE_TINYJ       61                ; Advanced Logic Corp. TinyJ embedded processor family
%define ELF_MACHINE_X86_64      62                ; AMD x86-64 architecture
%define ELF_MACHINE_PDSP        63                ; Sony DSP Processor
%define ELF_MACHINE_PDP10       64                ; Digital Equipment Corp. PDP-10
%define ELF_MACHINE_PDP11       65                ; Digital Equipment Corp. PDP-11
%define ELF_MACHINE_FX66        66                ; Siemens FX66 microcontroller
%define ELF_MACHINE_ST9PLUS     67                ; STMicroelectronics ST9+ 8/16 bit microcontroller
%define ELF_MACHINE_ST7         68                ; STMicroelectronics ST7 8-bit microcontroller
%define ELF_MACHINE_68HC16      69                ; Motorola MC68HC16 Microcontroller
%define ELF_MACHINE_68HC11      70                ; Motorola MC68HC11 Microcontroller
%define ELF_MACHINE_68HC08      71                ; Motorola MC68HC08 Microcontroller
%define ELF_MACHINE_68HC05      72                ; Motorola MC68HC05 Microcontroller
%define ELF_MACHINE_SVX         73                ; Silicon Graphics SVx
%define ELF_MACHINE_ST19        74                ; STMicroelectronics ST19 8-bit microcontroller
%define ELF_MACHINE_VAX         75                ; Digital VAX
%define ELF_MACHINE_CRIS        76                ; Axis Communications 32-bit embedded processor
%define ELF_MACHINE_JAVELIN     77                ; Infineon Technologies 32-bit embedded processor
%define ELF_MACHINE_FIREPATH    78                ; Element 14 64-bit DSP Processor
%define ELF_MACHINE_ZSP         79                ; LSI Logic 16-bit DSP Processor
%define ELF_MACHINE_MMIX        80                ; Donald Knuth's educational 64-bit processor
%define ELF_MACHINE_HUANY       81                ; Harvard University machine-independent object files
%define ELF_MACHINE_PRISM       82                ; SiTera Prism
%define ELF_MACHINE_AVR         83                ; Atmel AVR 8-bit microcontroller
%define ELF_MACHINE_FR30        84                ; Fujitsu FR30
%define ELF_MACHINE_D10V        85                ; Mitsubishi D10V
%define ELF_MACHINE_D30V        86                ; Mitsubishi D30V
%define ELF_MACHINE_V850        87                ; NEC v850
%define ELF_MACHINE_M32R        88                ; Mitsubishi M32R
%define ELF_MACHINE_MN10300     89                ; Matsushita MN10300
%define ELF_MACHINE_MN10200     90                ; Matsushita MN10200
%define ELF_MACHINE_PJ          91                ; picoJava
%define ELF_MACHINE_OPENRISC    92                ; OpenRISC 32-bit embedded processor
%define ELF_MACHINE_ARC_A5      93                ; ARC Cores Tangent-A5
%define ELF_MACHINE_XTENSA      94                ; Tensilica Xtensa Architecture
%define ELF_MACHINE_VIDEOCORE   95                ; Alphamosaic VideoCore processor
%define ELF_MACHINE_TMM_GPP     96                ; Thompson Multimedia General Purpose Processor
%define ELF_MACHINE_NS32K       97                ; National Semiconductor 32000 series
%define ELF_MACHINE_TPC         98                ; Tenor Network TPC processor
%define ELF_MACHINE_SNP1K       99                ; Trebia SNP 1000 processor
%define ELF_MACHINE_ST200       100               ; STMicroelectronics (www.st.com) ST200 microcontroller

struc elf32_header
	; unsigned char e_ident[EI_NIDENT]
	.ei_magic      : resb 4 ; elf magic number, should be ELF_MAGIC_NUMBER
	.ei_class      : resb 1 ; EI_CLASS enum value, tells if the elf is 32bits or 64bits
	.ei_data       : resb 1 ; EI_DATA enum value, tells if the elf is little-endian or big-endian
	.ei_version    : resb 1 ; elf version number, should always be equal to EV_CURRENT
	.ei_osabi      : resb 1 ; EI_OSABI enum value, tells what ABI the elf file uses
	.ei_abiversion : resb 1 ; the version of the ABI used by the elf file
	.ei_pad        : resb 7 ; unused padding bytes

	; More identification fields
	.e_type        : resw 1 ; ELF_TYPE enum value, tells what kind of elf file we're dealing with
	.e_machine     : resw 1 ; ELF_MACHINE enum value, the target architecture of this elf file
	.e_version     : resd 1 ; Elf_Word, duplicate of .ei_version
	
	; Program headers and Section headers informations
	.e_entry       : resd 1 ; Elf32_Addr, either entry point(execuatble), construtor addr(shared libraries)
	.e_phoff       : resd 1 ; Elf32_Off, program headers offset relative to the start of the elf file
	.e_shoff       : resd 1 ; Elf32_Off, section headers offset relative to the start of the elf file
	.e_flags       : resd 1 ; Elf_Word, processor specific flags
	.e_ehsize      : resw 1 ; Elf_Half, size of the elf header itself
	.e_phentsize   : resw 1 ; Elf_Half, size of a program header entry
	.e_phnum       : resw 1 ; Elf_Half, number of program header entry
	.e_shentsize   : resw 1 ; Elf_Half, size of a section header entry
	.e_shnum       : resw 1 ; Elf_Half, number of section header entry
	.e_shstrndx    : resw 1 ; Elf_Half, names of the sections in the file, 'sections' as in 'section header'
endstruc

struc elf64_header
	; unsigned char e_ident[EI_NIDENT]
	.ei_magic      : resb 4 ; elf magic number, should be ELF_MAGIC_NUMBER
	.ei_class      : resb 1 ; EI_CLASS enum value, tells if the elf is 32bits or 64bits
	.ei_data       : resb 1 ; EI_DATA enum value, tells if the elf is little-endian or big-endian
	.ei_version    : resb 1 ; elf version number, should always be equal to EV_CURRENT
	.ei_osabi      : resb 1 ; EI_OSABI enum value, tells what ABI the elf file uses
	.ei_abiversion : resb 1 ; the version of the ABI used by the elf file
	.ei_pad        : resb 7 ; unused padding bytes

	; More identification fields
	.e_type        : resw 1 ; ELF_TYPE enum value, tells what kind of elf file we're dealing with
	.e_machine     : resw 1 ; ELF_MACHINE enum value, the target architecture of this elf file
	.e_version     : resd 1 ; Elf_Word, duplicate of .ei_version
	
	; Program headers and Section headers informations
	.e_entry       : resq 1 ; Elf64_Addr, either entry point(execuatble), construtor addr(shared libraries)
	.e_phoff       : resq 1 ; Elf64_Off, program headers offset relative to the start of the elf file
	.e_shoff       : resq 1 ; Elf64_Off, section headers offset relative to the start of the elf file
	.e_flags       : resd 1 ; Elf_Word, processor specific flags
	.e_ehsize      : resw 1 ; Elf_Half, size of the elf header itself
	.e_phentsize   : resw 1 ; Elf_Half, size of a program header entry
	.e_phnum       : resw 1 ; Elf_Half, number of program header entry
	.e_shentsize   : resw 1 ; Elf_Half, size of a section header entry
	.e_shnum       : resw 1 ; Elf_Half, number of section header entry
	.e_shstrndx    : resw 1 ; Elf_Half, names of the sections in the file, 'sections' as in 'section header'
endstruc

%endif ; ELF_INC
