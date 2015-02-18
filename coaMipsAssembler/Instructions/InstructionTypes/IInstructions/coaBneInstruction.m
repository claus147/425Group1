classdef coaBneInstruction < coaIInstruction
    
    methods
        
        function obj = coaBneInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('5');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
        end
        
    end
    
end