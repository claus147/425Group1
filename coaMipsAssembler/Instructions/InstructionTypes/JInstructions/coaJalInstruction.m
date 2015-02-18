classdef coaJalInstruction < coaJInstruction
    
    methods
        
        function obj = coaJalInstruction(location,offset,label)
            
            opcode = hex2dec('3');
            
            address = str2double(location) + 1 + str2double(offset);
            
            obj@coaJInstruction(location,opcode,rs,address,label);
            
        end
        
    end
    
end