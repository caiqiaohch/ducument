/***
给定一个整数数组 nums 和一个整数目标值 target，请你在该数组中找出 和为目标值 target  的那 两个 整数，并返回它们的数组下标。

你可以假设每种输入只会对应一个答案。但是，数组中同一个元素在答案里不能重复出现。

你可以按任意顺序返回答案。

 

示例 1：

输入：nums = [2,7,11,15], target = 9
输出：[0,1]
解释：因为 nums[0] + nums[1] == 9 ，返回 [0, 1] 。
示例 2：

输入：nums = [3,2,4], target = 6
输出：[1,2]
示例 3：

输入：nums = [3,3], target = 6
输出：[0,1]
 

提示：

2 <= nums.length <= 104
-109 <= nums[i] <= 109
-109 <= target <= 109
只会存在一个有效答案
进阶：你可以想出一个时间复杂度小于 O(n2) 的算法吗？

来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/two-sum
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。

执行用时：
12 ms
, 在所有 C++ 提交中击败了
78.26%
的用户
内存消耗：
11.6 MB
, 在所有 C++ 提交中击败了
10.76%
的用户

**/
#include <vector>
#include <map>
#include <iostream>
using namespace std;
class Solution{
public:
    vector<int> twoSum(vector<int>& nums, int target){
         map<int,int> mp;
          int size = nums.size();
          int num1,num2;
		  vector<int> re;
          for(int i = 0; i<size; i++){
              num2 = target-nums[i]; 
              if(mp[num2]){
                   int k = mp[num2]-1;
                   if(i<k){
						re.push_back(i);
						re.push_back(k);
                    }   
                   else{
						re.push_back(k);
						re.push_back(i);
                   }
				   return re;
              }
              mp[nums[i]] = i+1;
        }
        vector<int> de(0,0);
        return de;
    }
};

void ShowVec(const vector<int>& valList)
{
    int count = valList.size();
        for (int i = 0; i < count;i++)
        {
                    cout << valList[i] << endl;             
        }          
}

int main(){
    Solution slo;
    vector<int> num ={2,7,11,15};
    vector<int> path = slo.twoSum(num,9);
    ShowVec(path);
    return 1;
}
