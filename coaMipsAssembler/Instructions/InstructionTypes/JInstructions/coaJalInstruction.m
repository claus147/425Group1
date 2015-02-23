classdef coaJalInstruction < coaJInstruction
    
    methods
        
        function obj = coaJalInstruction(location,offset,label)
            
            opcode = hex2dec('3');
            
            address = location + 1 + str2double(offset);
            
            obj@coaJInstruction(location,opcode,address,label);
            
        end
        
    end
    
end