/***
给你一个 32 位的有符号整数 x ，返回将 x 中的数字部分反转后的结果。

如果反转后整数超过 32 位的有符号整数的范围 [−231,  231 − 1] ，就返回 0。

假设环境不允许存储 64 位整数（有符号或无符号）。
 

示例 1：

输入：x = 123
输出：321
示例 2：

输入：x = -123
输出：-321
示例 3：

输入：x = 120
输出：21
示例 4：

输入：x = 0
输出：0
 

提示：

-231 <= x <= 231 - 1

来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/reverse-integer
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。
**/
#include <vector>
#include <map>
#include <iostream>
#include <cmath>
using namespace std;

class Solution {
public:

    void ShowVec(const vector<int>& valList)                                                                                                      
    {                                                                                    
        int count = valList.size();                                                           
         for (int i = 0; i < count;i++) { 
          cout << valList[i] << endl;
        }                                                                                                   
    }
    int reverse(int x) {
     vector<int> vec;
     int re =0;
     long i = x; 
     while(i){
       re = i%10;
       i = floor(i/10);
       if(re!=0)
            vec.push_back(re);
       else if(vec.size())
          vec.push_back(re);
     }
     int size = vec.size();
     long k = 0;
     for(int j = 0; j<size; j++){ 
         if(k==0)
             k = vec[j];
         else
             k =k*10+ vec[j];        
     }
     int end = k;
     if (k==end)
        return k;
     else 
      return 0;
    }

    int reverse2(int x)
    {
      int max = 2^31 - 1;
      int min= - 2^31;
      long n = 0;
      while (x) {
        n = n * 10 + x % 10;
        x /= 10;
      }
      return n > max || n < min ? 0 : n;
    }
    // int reverse3(int x) {
    //     int res;
    //     // 转字符串
    //     string itos=to_string(x);
    //     // 字符串反转
    //     std::reverse(itos.begin(),itos.end());
    //     // 溢出捕获异常
    //     try{
    //         res=stoi(itos);
    //     }catch(...){
    //         res=0;
    //     }
    //     if(x<0){
    //         res=-1*res;
    //     }
    //     return res;  
    // }
};

void ShowVec(const vector<int>& valList)
{
    int count = valList.size();
    for (int i = 0; i < count;i++) {
      cout << valList[i] << endl;             
    }
}

int main(){
   Solution slo;
   int k = 1534236469;
    cout<< "k:"<< k<<endl;  
   int path = slo.reverse(k);
   cout<< "path:"<< path<<endl;
    cout<< "k:"<< k<<endl;  
   path = slo.reverse2(k);
   cout<< "path:"<< path<<endl;
    return path;
}
