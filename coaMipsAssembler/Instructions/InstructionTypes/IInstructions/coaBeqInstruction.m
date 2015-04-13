classdef coaBeqInstruction < coaIInstruction
    
    methods
        
        function obj = coaBeqInstruction(location,rs,rt,immediate,label)
            
            opcode = hex2dec('4');
            
            obj@coaIInstruction(location,opcode,rs,rt,immediate,label);
            
            obj.Graph = {[],rs,rt};
            
        end
        
    end
    
end