classdef coaLuiInstruction < coaIInstruction
    
    methods
        
        function obj = coaLuiInstruction(location,rt,immediate,label)
            
            opcode = hex2dec('f');
            
            rs = '$0';
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
        end
        
    end
    
end