classdef coaLbInstruction < coaIInstruction
    
    methods
        
        function obj = coaLbInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('20');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
        end
        
    end
    
end