错误：TypeError: Cannot read property ‘then‘ of undefined

今天写代码的时候遇到了一个错误，找了很久都没发现原因
错误代码：

    saveData() {
      courseApi.saveCourseInfo(this.courseInfo).then(response => {})
    }

控制台报错信息：

vue.runtime.esm.js:1737 TypeError: Cannot read property 'then' of undefined
    at VueComponent.saveData (Info.vue?7610:178)
    at VueComponent.saveAndNext (Info.vue?7610:111)
    at click (Info.vue?2dda:217)
    at VueComponent.invoker (vue.runtime.esm.js:2023)
    at VueComponent.Vue.$emit (vue.runtime.esm.js:2534)
    at VueComponent.handleClick (element-ui.common.js:9727)
    at invoker (vue.runtime.esm.js:2023)
    at HTMLButtonElement.fn._withTask.fn._withTask (vue.runtime.esm.js:1822)

问题原因：saveCourseInfo(this.courseInfo)方法没有返回值，把courseApi.saveCourseInfo(this.courseInfo) 方法的结果打印出来发现时undefined ，原来是这个方法写的时候忘记加return了

saveCourseInfo(courseInfo) {
    request({
      url: '/admin/edu/course/save-course-info',
      method: 'post',
      data: courseInfo
    })
  }

然后在request前面加个return就可以了，发现它的返回值是 Promise

————————————————
版权声明：本文为CSDN博主「qq_42008471」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_42008471/article/details/107753515