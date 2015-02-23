classdef coaJumpInstruction < coaJInstruction
    
    methods
        
        function obj = coaJumpInstruction(location,offset,label)
            
            opcode = hex2dec('2');
            
            address = location + 1 + str2double(offset);
            
            obj@coaJInstruction(location,opcode,address,label);
            
        end
        
    end
    
end