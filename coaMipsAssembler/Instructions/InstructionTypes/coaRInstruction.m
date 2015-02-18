classdef coaRInstruction < coaInstruction
  
    properties
        
        Rd
        Shamt
        Funct
        
    end
    
    methods
        
        function obj = coaRInstruction(location, rs, rt, rd, shamt, funct, label)
            
            obj = obj.SetOpcode(0);
            obj.Type = 'R';
            
            rs = str2double(strrep(rs,'$',''));
            rt = str2double(strrep(rt,'$',''));
            rd = str2double(strrep(rd,'$',''));
            shamt = str2double(shamt);
            
            obj.Label = label;
            
            obj = obj.SetLocation(location);
            obj = obj.SetRs(rs);
            obj = obj.SetRt(rt);
            obj = obj.SetRd(rd);
            obj = obj.SetShamt(shamt);
            obj = obj.SetFunct(funct);
            
            obj.Output = [obj.Opcode, obj.Rs,obj.Rt,obj.Rd,obj.Shamt,obj.Funct];
            
        end
        
    end
    
    methods (Access = protected)
        
        
        function obj = SetRd(obj,rd)
            
            obj.Rd = dec2bin(rd,5);
            
        end
        
        function obj = SetShamt(obj,shamt)
            
            obj.Shamt = dec2bin(shamt,5);
            
        end
        
        function obj = SetFunct(obj,funct)
            
            obj.Funct = dec2bin(hex2dec(funct),6);
            
        end
        
    end
    
end