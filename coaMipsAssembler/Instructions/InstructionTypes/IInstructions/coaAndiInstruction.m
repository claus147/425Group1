classdef coaAndiInstruction < coaIInstruction
    
    methods
        
        function obj = coaAndiInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('c');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
            obj.Graph = {rt,rs,[]};
            
        end
        
    end
    
end