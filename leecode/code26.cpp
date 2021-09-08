/***
*26. 删除有序数组中的重复项
* 给你一个有序数组 nums ，请你 原地 删除重复出现的元素，使每个元素 只出现一次 ，返回删除后数组的新长度。
*不要使用额外的数组空间，你必须在 原地 修改输入数组 并在使用 O(1) 额外空间的条件下完成。
* ****/
#include <vector>
#include <map>
#include <iostream>
using namespace std;

class Solution {
public:
    int removeDuplicates(vector<int>& nums){
        int size = nums.size();
        if(size<2)
            return size;
        int i = 0;
        int j = 1;
        while( j<size){
            if(nums[i]!=nums[j]){
                i++;
                nums[i] = nums[j];
            }
            j++;
        }
        return i+1;
    }
    int removeDuplicates_2(vector<int>& nums){
        int size = nums.size();
        int i = 0;
        while( (i+1)<size){
            int k1 = nums[i];
            int k2 = nums[i+1];
            if(k1==k2){
              nums.erase(nums.begin()+i);
              size--;
            }
            else{
                i++;
            }
        }
        return size;
    }

     void ShowVec(const vector<int>& valList)
     {       
         int count = valList.size();
         for( int i = 0; i < count; i++  ){
            cout << valList[i] << endl;
         }          
            
     }
};

void ShowVec(const vector<int>& valList)
{
    int count = valList.size();
    for( int i = 0; i < count; i++ ){
        cout << valList[i] << endl;
    }
}

int main() {
    Solution slo;
    vector<int> num = {0,0,1,1,1,2,2,3,3,4};
 //   vector<int> num = {1,1,2};
    ShowVec(num);
    int size  = slo.removeDuplicates(num);
    cout << "size:" << size << endl;
}
