classdef coaMfhiInstruction < coaRInstruction
    
    methods
        
        function obj = coaMfhiInstruction(location,rd,label)
            
            rs = '$0';
            rt = '$0';
            shamt = '0';
            funct = '10';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end