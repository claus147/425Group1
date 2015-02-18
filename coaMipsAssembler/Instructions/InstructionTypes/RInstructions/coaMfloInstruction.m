classdef coaMfloInstruction < coaRInstruction
    
    methods
        
        function obj = coaMfloInstruction(location,rd,label)
            
            rs = '$0';
            rt = '$0';
            shamt = '0';
            funct = '12';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end