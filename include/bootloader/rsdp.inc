%ifndef RSDP_INC
%define RSDP_INC

%define BIOS_MEMORY_REGION 0xE0000
%define BIOS_MEMORY_REGION_SIZE 0x20000
%define BIOS_MEMORY_REGION_END (BIOS_MEMORY_REGION + BIOS_MEMORY_REGION_SIZE)

%define EBDA_MEMORY 0x80000
%define EBDA_SIZE 0x400
%define EBDA_MEMORY_END (EBDA_MEMORY + EBDA_SIZE)

%define RSDP_COPY_MEMORY_BOUNDARY 0x500000
%define FADT_COPY_MEMORY_BOUNDARY 0x500400
%define DSDT_COPY_MEMORY_BOUNDARY 0x500800

struc RSDP
	.Signature: resb 8
	.Checksum: resb 1
	.OEMID: resb 6
	.Revision: resb 1
	.RsdtAddress: resd 1
endstruc

struc XSDP
	.Signature: resb 8
	.Checksum: resb 1
	.OEMID: resb 6
	.Revision: resb 1
	.RsdtAddress: resd 1

    .Length: resd 1
    .XsdtAddress: resq 1
    .ExtendedChecksum: resb 1
    .reserved: resb 3
endstruc

struc ACPISDTHeader
	.Signature: resb 4
	.Length: resd 1
	.Revision: resb 1
	.Checksum: resb 1
	.OEMID: resb 6
	.OEMTableID: resb 8
	.OEMRevision: resd 1
	.CreatorID: resd 1
	.CreatorRevision: resd 1
endstruc

struc RSDT
	;ACPISDTHeader header
		.Signature: resb 4
		.Length: resd 1
		.Revision: resb 1
		.Checksum: resb 1
		.OEMID: resb 6
		.OEMTableID: resb 8
		.OEMRevision: resd 1
		.CreatorID: resd 1
		.CreatorRevision: resd 1

	.PointerToOtherSDT: resd 1;is actually an array of size (h.len - sizeof(Header))/4
endstruc

struc XSDT
	;ACPISDTHeader header
		.Signature: resb 4
		.Length: resd 1
		.Revision: resb 1
		.Checksum: resb 1
		.OEMID: resb 6
		.OEMTableID: resb 8
		.OEMRevision: resd 1
		.CreatorID: resd 1
		.CreatorRevision: resd 1

	.PointerToOtherSDT: resd 1;is actually an array of size (h.len - sizeof(Header))/8
endstruc

struc GenericAddressStructure
  .AddressSpace: resb 1
  .BitWidth: resb 1
  .BitOffset: resb 1
  .AccessSize: resb 1
  .Address: resb 1
endstruc

struc FADT
	;ACPISDTHeader header
		.Signature: resb 4
		.Length: resd 1
		.Revision: resb 1
		.Checksum: resb 1
		.OEMID: resb 6
		.OEMTableID: resb 8
		.OEMRevision: resd 1
		.CreatorID: resd 1
		.CreatorRevision: resd 1

	.FirmwareCtrl: resd 1
	.Dsdt: resd 1

	.Reserved: resb 1

	.PreferredPowerManagementProfile: resb 1
    .SCI_Interrupt: resw 1
    .SMI_CommandPort: resd 1
    .AcpiEnable: resb 1
    .AcpiDisable: resb 1
    .S4BIOS_REQ: resb 1
    .PSTATE_Control: resb 1
    .PM1aEventBlock: resd 1
    .PM1bEventBlock: resd 1
    .PM1aControlBlock: resd 1
    .PM1bControlBlock: resd 1
    .PM2ControlBlock: resd 1
    .PMTimerBlock: resd 1
    .GPE0Block: resd 1
    .GPE1Block: resd 1
    .PM1EventLength: resb 1
    .PM1ControlLength: resb 1
    .PM2ControlLength: resb 1
    .PMTimerLength: resb 1
    .GPE0Length: resb 1
    .GPE1Length: resb 1
    .GPE1Base: resb 1
    .CStateControl: resb 1
    .WorstC2Latency: resw 1
    .WorstC3Latency: resw 1
    .FlushSize: resw 1
    .FlushStride: resw 1
    .DutyOffset: resb 1
    .DutyWidth: resb 1
    .DayAlarm: resb 1
    .MonthAlarm: resb 1
    .Century: resb 1

	;used since ACPI 2.0+
    .BootArchitectureFlags: resw 1

    .Reserved2: resb 1
    .Flags: resd 1

    ;GenericAddressStructure ResetReg
		.ResetReg_AddressSpace: resb 1
		.ResetReg_BitWidth: resb 1
		.ResetReg_BitOffset: resb 1
		.ResetReg_AccessSize: resb 1
		.ResetReg_Address: resb 1
    .ResetValue: resb 1
    .Reserved3: resb 3
  
    .X_FirmwareControl: resq 1
    .X_Dsdt: resq 1

	;GenericAddressStructure X_PM1aEventBlock
		.X_PM1aEventBlock_AddressSpace: resb 1
		.X_PM1aEventBlock_BitWidth: resb 1
		.X_PM1aEventBlock_BitOffset: resb 1
		.X_PM1aEventBlock_AccessSize: resb 1
		.X_PM1aEventBlock_Address: resb 1
    ;GenericAddressStructure X_PM1bEventBlock
		.X_PM1bEventBlock_AddressSpace: resb 1
		.X_PM1bEventBlock_BitWidth: resb 1
		.X_PM1bEventBlock_BitOffset: resb 1
		.X_PM1bEventBlock_AccessSize: resb 1
		.X_PM1bEventBlock_Address: resb 1
    ;GenericAddressStructure X_PM1aControlBlock
		.X_PM1aControlBlock_AddressSpace: resb 1
		.X_PM1aControlBlock_BitWidth: resb 1
		.X_PM1aControlBlock_BitOffset: resb 1
		.X_PM1aControlBlock_AccessSize: resb 1
		.X_PM1aControlBlock_Address: resb 1
    ;GenericAddressStructure X_PM1bControlBloc
		.X_PM1bControlBloc_AddressSpace: resb 1
		.X_PM1bControlBloc_BitWidth: resb 1
		.X_PM1bControlBloc_BitOffset: resb 1
		.X_PM1bControlBloc_AccessSize: resb 1
		.X_PM1bControlBloc_Address: resb 1
    ;GenericAddressStructure X_PM2ControlBlock
		.X_PM2ControlBlock_AddressSpace: resb 1
  		.X_PM2ControlBlock_BitWidth: resb 1
  		.X_PM2ControlBlock_BitOffset: resb 1
  		.X_PM2ControlBlock_AccessSize: resb 1
  		.X_PM2ControlBlock_Address: resb 1
    ;GenericAddressStructure X_PMTimerBlock
		.X_PMTimerBlock_AddressSpace: resb 1
  		.X_PMTimerBlock_BitWidth: resb 1
  		.X_PMTimerBlock_BitOffset: resb 1
  		.X_PMTimerBlock_AccessSize: resb 1
  		.X_PMTimerBlock_Address: resb 1
    ;GenericAddressStructure X_GPE0Block
		.X_GPE0Block_AddressSpace: resb 1
 		.X_GPE0Block_BitWidth: resb 1
 		.X_GPE0Block_BitOffset: resb 1
  		.X_GPE0Block_AccessSize: resb 1
  		.X_GPE0Block_Address: resb 1
    ;GenericAddressStructure X_GPE1Block
		.X_GPE1Block_AddressSpace: resb 1
  		.X_GPE1Block_BitWidth: resb 1
  		.X_GPE1Block_BitOffset: resb 1
  		.X_GPE1Block_AccessSize: resb 1
  		.X_GPE1Block_Address: resb 1
endstruc

extern find_RSDP



%endif ;RSDP_INC