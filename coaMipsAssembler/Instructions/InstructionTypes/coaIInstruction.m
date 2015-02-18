classdef coaIInstruction < coaInstruction
  
    properties
        
        Immediate
        
    end
    
    methods
        
        function obj = coaIInstruction(location,opcode,rs,rt,immediate,label)
            
            obj = obj.SetLocation(location);
            obj.Label = label;
            obj = obj.SetOpcode(opcode);
            obj.Type = 'I';
            
            rs = str2double(strrep(rs,'$',''));
            rt = str2double(strrep(rt,'$',''));
            immediate = str2double(immediate);
            
            obj = obj.SetRs(rs);
            obj = obj.SetRt(rt);
            obj = obj.SetImmediate(immediate);
            
            obj.Output = [obj.Opcode, obj.Rs,obj.Rt,obj.Immediate];
            
        end
        
    end
    
    methods (Access = protected)
        
        function obj = SetImmediate(obj,immediate)
            
            obj.Immediate = dec2twos(immediate,16);
            
        end
        
    end
    
end