classdef coaSwInstruction < coaIInstruction
    
    methods
        
        function obj = coaSwInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('2b');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
        end
        
    end
    
end