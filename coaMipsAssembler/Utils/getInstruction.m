function instruction = getInstruction(parsed_list_entry, location)

    mnem = parsed_list_entry{1};
    type = parsed_list_entry{2};
    arg_1 = parsed_list_entry{3};
    arg_2 = parsed_list_entry{4};
    arg_3 = parsed_list_entry{5};
    label = parsed_list_entry{6};

    switch type
        
        case 'R'
            
            switch mnem
                
                case 'add'
                    
                    instruction = coaAddInstruction(location,arg_2,arg_3,arg_1,label);
                    
                case 'and'
                    
                    instruction = coaAndInstruction(location,arg_2,arg_3,arg_1,label);
                    
                case 'div'
                    
                    instruction = coaDivInstruction(location,arg_1,arg_2,label);
                    
                case 'jr'
                    
                    instruction = coaJrInstruction(location,arg_1,label);
                    
                case 'mfhi'
                    
                    instruction = coaMfhiInstruction(location,arg_1,label);
                    
                case 'mflo'
                    
                    instruction = coaMfloInstruction(location,arg_1,label);
                    
                case 'mult'
                    
                    instruction = coaMultInstruction(location,arg_1,arg_2,label);
                    
                case 'nor'
                    
                    instruction = coaNorInstruction(location,arg_2,arg_3,arg_1,label);
                    
                case 'or'
                    
                    instruction = coaOrInstruction(location,arg_2,arg_3,arg_1,label);
                    
                case 'slt'
                    
                    instruction = coaSltInstruction(location,arg_2,arg_3,arg_1,label);
                    
                case 'sll'
                    
                    instruction = coaSllInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'sra'
                    
                    instruction = coaSraInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'srl'
                    
                    instruction = coaSrlInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'sub'
                    
                    instruction = coaSubInstruction(location,arg_2,arg_3,arg_1,label);
                    
                case 'xor'
                    
                    instruction = coaXorInstruction(location,arg_2,arg_3,arg_1,label);
                    
            end
                
            
        case 'I'
            
            switch mnem
                
                case 'addi'
                    
                    instruction = coaAddiInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'andi'
                    
                    instruction = coaAndiInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'beq'
                    
                    instruction = coaBeqInstruction(location,arg_1,arg_2,arg_3,label);
                    
                case 'bne'
                    
                    instruction = coaBneInstruction(location,arg_1,arg_2,arg_3,label);
                    
                case 'lb'
                    
                    instruction = coaLbInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'lui'
                    
                    instruction = coaLuiInstruction(location,arg_1,arg_2,label);
                    
                case 'lw'
                    
                    instruction = coaLwInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'ori'
                    
                    instruction = coaOriInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'slti'
                    
                    instruction = coaSltiInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'sb'
                    
                    instruction = coaSbInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'sw'
                    
                    instruction = coaSwInstruction(location,arg_2,arg_1,arg_3,label);
                    
                case 'xori'
               
                    instruction = coaXoriInstruction(location,arg_2,arg_1,arg_3,label);
                    
            end     
            
        case 'J'
            
            switch mnem
                
                case 'j'
                    
                    instruction = coaJumpInstruction(location,arg_1,label);
                    
                case 'jal' 
                    
                    instruction = coaJalInstruction(location,arg_1,label);
                
            end
            
    end
    
end