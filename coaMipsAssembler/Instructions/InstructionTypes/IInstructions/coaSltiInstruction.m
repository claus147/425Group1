classdef coaSltiInstruction < coaIInstruction
    
    methods
        
        function obj = coaSltiInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('a');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
        end
        
    end
    
end