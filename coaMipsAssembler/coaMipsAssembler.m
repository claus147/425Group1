function coaMipsAssembler(file_in,file_out)

    list = coaParseAssembly(file_in);
    machine_instructions = getMachineInstructions(list);
    
    dlmwrite(file_out,machine_instructions,'');

end