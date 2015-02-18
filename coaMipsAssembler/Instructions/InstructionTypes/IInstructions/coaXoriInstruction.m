classdef coaXoriInstruction < coaIInstruction
    
    methods
        
        function obj = coaXoriInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('e');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
        end
        
    end
    
end