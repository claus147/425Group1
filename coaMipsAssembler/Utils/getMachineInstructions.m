function machine_instructions = getMachineInstructions(parsed_list)

    [inst_count,~] = size(parsed_list);
    
    machine_instructions = [];
    
    
    for n = 1:inst_count
        
        instruction = getInstruction(parsed_list(n,:),n-1);
        machine_instructions = cat(1,machine_instructions,instruction.Output);
        
    end

end