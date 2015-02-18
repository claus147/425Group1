classdef coaSbInstruction < coaIInstruction
    
    methods
        
        function obj = coaSbInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('28');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
        end
        
    end
    
end