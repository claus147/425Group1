classdef coaLwInstruction < coaIInstruction
    
    methods
        
        function obj = coaLwInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('23');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
        end
        
    end
    
end