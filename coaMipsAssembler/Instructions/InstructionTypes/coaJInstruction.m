classdef coaJInstruction < coaInstruction
  
    properties
        
        Address
        
    end
    
    methods
        
        function obj = coaJInstruction(location,opcode,address,label)
            
            obj = obj.SetLocation(location);
            obj.Label = label;
            obj = obj.SetOpcode(opcode);
            obj.Type = 'J';
            
            obj = obj.SetAddress(address);
            
            obj.Output = [obj.Opcode,obj.Address];
           
            
        end
        
    end
    
    methods (Access = protected)
        
        function obj = SetAddress(obj,address)
            
            obj.Address = dec2bin(address,26);
            
        end
        
    end
    
end