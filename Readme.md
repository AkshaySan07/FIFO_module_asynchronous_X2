# Asynchronous FIFO
The repo contains all the modules and testbenchs required for simulation.  
top_module instantiates all the submodule of the project.
#### The testcases used for verification of the design are:  
-Write and Read , Read without write.  
-Multiple Writes and Reads  
-Full FIFO Test (Write till gets full)  
-Empty FIFO Test (read till it gets empty)  
-Simultaneous Write and Read  
-Boundary Write/Read (write till almost Full and read till almost Empty)  
-Write after Reset and Read after Reset  
-Full and Empty Flags Verification  
-Overfill the FIFO  
-Underflow the FIFO  
-Randomized Write/Read Sequence  
-Write read AFIFO with depth=2 (Cross-Clock Domain Synchronization test )  
-Asynchronous reset verification (Reset abruptly and check for data through read)  

    
## Marker design and justification
![image](https://github.com/user-attachments/assets/4e316043-4104-4ed3-87f8-a339b71872cc)  

#### Added 2 other ways to clear the marker value.   
-Maker is cleared when the write overwrites the marker position (ex: if red_enable is always low and the marker is generated at some 105 position and wptr goes to 0 then it starts writing again until full so after it is full wrt_enable is bought low and red_enable becomes high then when the rptr reaches marker it should not be rst as the marker is not relevant after the values until the marker are overwritten by wptr. So as wptr crosses marker the marker becomes 0).  
-2nd condition is rst_r, if the reading side is reset then there is no point of having a marker (ex: if clk_w and clk_r are equal and are reading writing continuously and both of them are reset at 105 position then there is no need for a marker cause as they both pass through that again then only rptr will be reset to zero and the rptr is suddenly for no reason 105 positions behind wptr).


