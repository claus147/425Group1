function hexlist = coaMipsAssembler(file_in,file_out)

    list = coaParseAssembly(file_in);
    machine_instructions = getMachineInstructions(list);
    [numInst,~] = size(machine_instructions);
    
    hexlist = [];
    
    for n = 1:numInst
       
        hexlist = cat(1,hexlist,dec2hex(bin2dec(machine_instructions(n,:)),8));
        
    end
    
    dlmwrite(file_out,machine_instructions,'');

end