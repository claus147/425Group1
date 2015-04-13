classdef coaInstruction
  
    properties
        
        Mnem        % Mnemonic Id
        Type        % Specify R,I,J
        Opcode      % opcode for MIPS instruction 
        Label       
        Location    % Location of instruction in memory
        Output      % Machine Language Output
        Rs
        Rt
        Graph
        
    end
    
    methods
        
        function obj = coaInstruction()
            
            
            
        end
        
    end
    
    methods (Access = protected)
        
        function obj = SetOpcode(obj,opcode)
            
            obj.Opcode = dec2bin(opcode,6);
            
        end
        
        function obj = SetLocation(obj,location)
            
            obj.Location = dec2bin(location,6);
            
        end
        
        function obj = SetRs(obj,rs)
            
            obj.Rs = dec2bin(rs,5);
            
        end
        
        function obj = SetRt(obj,rt)
            
            obj.Rt = dec2bin(rt,5);
            
        end
        
    end
    
end