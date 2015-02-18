classdef coaOriInstruction < coaIInstruction
    
    methods
        
        function obj = coaOriInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('d');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
        end
        
    end
    
end