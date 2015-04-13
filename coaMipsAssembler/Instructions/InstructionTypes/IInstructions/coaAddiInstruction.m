classdef coaAddiInstruction < coaIInstruction
    
    methods
        
        function obj = coaAddiInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('8');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
            obj.Graph = {rt,rs,[]};
            
        end
        
    end
    
end