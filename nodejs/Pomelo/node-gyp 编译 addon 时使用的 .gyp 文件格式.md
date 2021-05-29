node-gyp 编译 addon 时使用的 .gyp 文件格式
 2017年11月26日     3876     声明



Node.js基于GYP（Generate Your Projects）构建C\C++插件，在编译插件前需要编写一个.gyp配置文件，该文件相当于CMake中使用的CMakeLists.txt。

介绍
一个典型的Chromium.gyp文件结构
.gyp文件中典型的可执行目标(executable target)的结构
.gyp文件中典型的库目标(library target)的结构
一些用例
5.1 添回一个新的源文件
5.2 添加一个新的可执行目标
5.3 向目标中添加设置
5.4 交叉编译
5.5 添加一个新库
5.6 两个目标之间的依赖关系
5.7 支持Mac OS X绑定
1. 介绍
GYP（Generate Your Projects）是一个跨平台自动化项目构建工具，其由 Google 团队开发用于生成 Chromium Web浏览器的原生IDE的项目文件。

因工作需要，要在项目中基于一个第三方动态库，编写一个在Node中调用的addon。所以参考官方文档，整理下.gyp文件相关内容。

在本文中，分别提供了：.gyp文件本身结构介绍、.gyp文件中典型的可执行程序目标(executable target)的结构介绍、.gyp文件中典型的库目标(library target)结构介绍，其后结合一些用例做进一步介绍。



2. 一个典型的Chromium.gyp文件结构
以下是Chromium中典型的.gyp文件结构：

{
  'variables': {
    .
    .
    .
  },
  'includes': [
    '../build/common.gypi',
  ],
  'target_defaults': {
    .
    .
    .
  },
  'targets': [
    {
      'target_name': 'target_1',
        .
        .
        .
    },
    {
      'target_name': 'target_2',
        .
        .
        .
    },
  ],
  'conditions': [
    ['OS=="linux"', {
      'targets': [
        {
          'target_name': 'linux_target_3',
            .
            .
            .
        },
      ],
    }],
    ['OS=="win"', {
      'targets': [
        {
          'target_name': 'windows_target_4',
            .
            .
            .
        },
      ],
    }, { # OS != "win"
      'targets': [
        {
          'target_name': 'non_windows_target_5',
            .
            .
            .
        },
    }],
  ],
}
整个文件就是一个Python字典，实际也是一个JSON文件，只有两点小区别：使用#号做注释、在列表或字典最后一个元素之后使用,是合法的。

.gyp文件的顶级节点如下：

'variables'：定义变量，可以在文件的其他部分内插和使用。
'includes'：将包含在本文件中的其他文件列表。 按照惯例，包含文件的后缀名为.gypi（gyp include）。
'target_defaults'：设置，将应用于本.gyp文件中定义的所有目标。
'targets'：这个.gyp文件可以生成的目标列表。 其中每个目标都是一个字典，包含了描述构建目标所需的所有设置信息。
'conditions'：条件规范列表，可以根据不同变量的值修改由该.gyp文件定义的全局字典中项目内容。如上例中，顶级字典中conditions部分的最常见用法是将平台相关的特定的目标添加到targets列表。


3. .gyp文件中典型的可执行目标(executable target)的结构
生成“可执行目标”即生成一个可执行程序。最直接的生成目标可能就是生成一个简单的可执行程序。以下是一个executable目标示例，它演示了gyp最简单的功能用法：

{
  'targets': [
    {
      'target_name': 'foo',
      'type': 'executable',
      'msvs_guid': '5ECEC9E5-8F23-47B6-93E0-C3B328B3BE65',
      'dependencies': [
        'xyzzy',
        '../bar/bar.gyp:bar',
      ],
      'defines': [
        'DEFINE_FOO',
        'DEFINE_A_VALUE=value',
      ],
      'include_dirs': [
        '..',
      ],
      'sources': [
        'file1.cc',
        'file2.cc',
      ],
      'conditions': [
        ['OS=="linux"', {
          'defines': [
            'LINUX_DEFINE',
          ],
          'include_dirs': [
            'include/linux',
          ],
        }],
        ['OS=="win"', {
          'defines': [
            'WINDOWS_SPECIFIC_DEFINE',
          ],
        }, { # OS != "win",
          'defines': [
            'NON_WINDOWS_DEFINE',
          ],
        }]
      ],
    },
  ],
}
在target中包含以下顶级设置：

'target_name'：目标名，在所有的.gyp文件中应该是唯一的。此名称将用于所成生的不同IDE的项目名，如：Visual Studio解决方案中的项目名称、Xcode配置中的目标名称、SCons配置的命令行构建此目标的别名。
'type'：设置为executable
'msvs_guid'：这只是过渡用法。用于将在生成的Visual Studio解决方案文件中使用的硬编码的GUID值，这使我们能够检查与gyp生成的项目文件互操作的chrome.sln文件。一旦Chromium中的所有内容都由gyp生成，GUID在调用中保持不变就不再重要了，我们就可以不在考虑这些设置，
'dependenciesdefines'：这个目标所依赖的其他目标列表。gyp生成的文件将保证其他目标在这个目标之前建立。任何dependencies列表中的库目标都将与此目标链接。此列表中的目标的direct_dependent_settings部分中列出的各种设置（define、include_dirs等）将应用于此目标的构建和链接方式。详见下面direct_dependent_settings介绍。
'defines'：将在编译命令行中传递的C预处理器定义（使用-D或/D选项）。
'include_dirs'：包含头文件的目录。将传递给编译命令行（使用-I或/I选项）。
'sources'：这个目标的源文件列表。
'conditions'：将根据匹配条件更新目标字典中的不同设置。


4. .gyp文件中典型的库目标(library target)的结构
大多数情况下，我们需要生成一个“库文件”而非“可执行程序”。以下是一个生成库目标的示例，其演示了生成库时所需要的大多功能：

{
  'targets': [
    {
      'target_name': 'foo',
      'type': '<(library)'
      'msvs_guid': '5ECEC9E5-8F23-47B6-93E0-C3B328B3BE65',
      'dependencies': [
        'xyzzy',
        '../bar/bar.gyp:bar',
      ],
      'defines': [
        'DEFINE_FOO',
        'DEFINE_A_VALUE=value',
      ],
      'include_dirs': [
        '..',
      ],
      'direct_dependent_settings': {
        'defines': [
          'DEFINE_FOO',
          'DEFINE_ADDITIONAL',
        ],
        'linkflags': [
        ],
      },
      'export_dependent_settings': [
        '../bar/bar.gyp:bar',
      ],
      'sources': [
        'file1.cc',
        'file2.cc',
      ],
      'conditions': [
        ['OS=="linux"', {
          'defines': [
            'LINUX_DEFINE',
          ],
          'include_dirs': [
            'include/linux',
          ],
        ],
        ['OS=="win"', {
          'defines': [
            'WINDOWS_SPECIFIC_DEFINE',
          ],
        }, { # OS != "win",
          'defines': [
            'NON_WINDOWS_DEFINE',
          ],
        }]
      ],
  ],
}
生成库目标与生成可执行目标的大多数配置条件是相同的（defines、include_dirs等）。但也有一些不同项，如：

'type'：几乎总是设置为'<(library)'，这允许用户定义在gyp每次生成的库是要建立静态库还是共享库。（在Linux中，共享库链接可节省大量链接时间）如果需要固定要构建的库的类型，则可以将类型显式设置为static_library或shared_library。
'direct_dependent_settings'：定义将被应用到直接依赖于这个目标的其他目标的设置，也就是说-这个目标会在经们的'dependencies'设置中列出。所列出的位置包括：defines、include_dirs、cflags、linkflags，其他目标的编译或链接应该与这个目标需要一一对应。
'export_dependent_settings'：这列出了'direct_dependent_settings'应该“传递”给使用（依赖于）这个目标的其他目标的目标。


5. 一些用例
以下是一些常用的GYP使用操作示例。请注意，这些示例并不是完整的，只包含了与示例相关的关键字和设置，可能还有一些额外的上下文关键字。旨在展示在某些工作时需要注意的具体部分。

5.1 添加一个新的源文件
添加独立于平台的源文件与添加仅在某些平台支持的源文件相似但略有不同。

添加一个在所有平台构建的源文件

添加在所有平台构建的源文件时，只需将文件添加到指定的targets中sources列表中即可：

 {
  'targets': [
    {
      'target_name': 'my_target',
      'type': 'executable',
      'sources': [
        '../other/file_1.cc',
        'new_file.cc',
        'subdir/file3.cc',
      ],
    },
  ],
},
所添加的文件路径，是相对于.gyp文件的路径。除非真的需要，否则就应该字线顺序排序。

添加一个平台相关的源文件

平台相关的问题被命名为：*_linux.{ext}、*_mac.{ext}、*_posix.{ext}或*_win.{ext}。

也就是说，你可以简单的使用以下标准后缀之一来添加特定于平台的源文件：

_linux (如 foo_linux.cc)
_mac (如 foo_mac.cc)
_posix (如 foo_posix.cc)
_win (如 foo_win.cc)
如，你可以像下面这样将文件添加到指定targets的sources列表中，即可添加平台相关的源文件：

{
  'targets': [
    {
      'target_name': 'foo',
      'type': 'executable',
      'sources': [
        'independent.cc',
        'specific_win.cc',
      ],
    },
  ],
},
Chromium .gyp文件会进行过滤，将不适合当前平台的文件过滤掉。在上面的示例中，specific_win.cc文件将会从非Windows版本的源列表中自动删除。

平台相关的文件不使用已经定义的模式

如果你的平台相关的文件名中不包含*_{linux,mac,posix,win}子字符串，而又不能修改文件名，可通过以下两种模式来进行平台匹配。

方法一：

可以将文件添加到指定targets的sources列表中，并添加一个conditions节点来排除指定的文件名：

 {
  'targets': [
    {
      'target_name': 'foo',
      'type': 'executable',
      'sources': [
        'linux_specific.cc',
      ],
      'conditions': [
        ['OS != "linux"', {
          'sources!': [
            # Linux-only; exclude on other platforms.
            'linux_specific.cc',
          ]
        }[,
      ],
    },
  ],
},
方法二：

在conditions中的sources中添加平台相关的文件：

{
  'targets': [
    {
      'target_name': 'foo',
      'type': 'executable',
      'sources': [],
      ['OS == "linux"', {
        'sources': [
          # Only add to sources list on Linux.
          'linux_specific.cc',
        ]
      }],
    },
  ],
},


5.2 添加一个新的可执行目标
一个可执行程序可能是最直接的目标类型，它通常需要的是一个源文件列表、一些编译器/链接器设置（因平台而异）、它依赖的一些库目标其必须用于最后的链接。>

适用于所有平台的可执行目标

将定义新的可执行目标的字典添加到.gyp文件的targets列表中。如：

{
  'targets': [
    {
      'target_name': 'new_unit_tests',
      'type': 'executable',
      'defines': [
        'FOO',
      ],
      'include_dirs': [
        '..',
      ],
      'dependencies': [
        'other_target_in_this_file',
        'other_gyp2:target_in_other_gyp2',
      ],
      'sources': [
        'new_additional_source.cc',
        'new_unit_tests.cc',
      ],
    },
  ],
}


适用于特定平台的可执行目标

添加适用于特定平台的可执行目标时，所定义的新的可执行目标不是添加到targets列表中，而是与其同级的顶级节点conditions中：

{
  'targets': [
  ],
  'conditions': [
    ['OS=="win"', {
      'targets': [
        {
          'target_name': 'new_unit_tests',
          'type': 'executable',
          'defines': [
            'FOO',
          ],
          'include_dirs': [
            '..',
          ],
          'dependencies': [
            'other_target_in_this_file',
            'other_gyp2:target_in_other_gyp2',
          ],
          'sources': [
            'new_additional_source.cc',
            'new_unit_tests.cc',
          ],
        },
      ],
    }],
  ],
}


5.3 向目标中添加设置
所有指定的目标，都可以定义几种不同类型的设置。

添加新的预处理器定义（-D或/D标识）

新的预处理器定义可以通过defines设置：

{
  'targets': [
    {
      'target_name': 'existing_target',
      'defines': [
        'FOO',
        'BAR=some_value',
      ],
    },
  ],
},
预处理器定义可以直接在targets设置中指定，也可以添加到conditions节点中。

添加新的包含目录（-I或/I标识）

新的包含目录通过include_dirs设置：

{
  'targets': [
    {
      'target_name': 'existing_target',
      'include_dirs': [
        '..',
        'include',
      ],
    },
  ],
},
包含目录定义可以直接在targets设置中指定，也可以添加到conditions节点中。

添加新的编译器标识

指定编译器标识时，可以通过cflags来设置：

  {
  'targets': [
    {
      'target_name': 'existing_target',
      'conditions': [
        ['OS=="win"', {
          'cflags': [
            '/WX',
          ],
        }, { # OS != "win"
          'cflags': [
            '-Werror',
          ],
        }],
      ],
    },
  ],
},
因为这些标识是因平台而定的，所以只能在conditions中设置。

添加新的链接器标识

指定链接器标识时，可以通过ldflags来设置：

{
  'targets': [
    {
      'target_name': 'existing_target',
      'conditions': [
        ['OS=="linux"', {
          'ldflags': [
            '-pthread',
          ],
        }],
      ],
    },
  ],
},
链接器标识同样是因平台而定的，所以也只能在conditions中设置。

按平台排除设置

任何设置（defines、include_dirs等）都可以通过!符号进行排除。如，我们可以在Linux平台下从build/common.gypi所定义的全局设置中排除-Werror标识：

  {
  'targets': [
    {
      'target_name': 'third_party_target',
      'conditions': [
        ['OS=="linux"', {
          'cflags!': [
            '-Werror',
          ],
        }],
      ],
    },
  ],
},


5.4 交叉编译
GYP有限的对交叉编译有一些支持。如果变量GYP_CROSSCOMPILE或其中一个工具链相关的变量（如 CC_host、CC_target）被设置，GYP会认为你希望进行交叉编译。

交叉编译时，每个目标可以是“host”版本或“target”版本。 默认情况下，目标被认为是仅“target”构建的一部分。 可以在目标上设置“toolsets”属性以更改默认值。



5.5 添加一个新库
添加一个适用于所有平台的库

添加定义的新的库目标时，可以将其添加到.gyp文件的targets列表中。如：

{
  'targets': [
    {
      'target_name': 'new_library',
      'type': '<(library)',
      'defines': [
        'FOO',
        'BAR=some_value',
      ],
      'include_dirs': [
        '..',
      ],
      'dependencies': [
        'other_target_in_this_file',
        'other_gyp2:target_in_other_gyp2',
      ],
      'direct_dependent_settings': {
        'include_dirs': '.',
      },
      'export_dependent_settings': [
        'other_target_in_this_file',
      ],
      'sources': [
        'new_additional_source.cc',
        'new_library.cc',
      ],
    },
  ],
}
以上的<(library)设置值是大多数库目标的默认类型设置，它允许开发人员在每次gyp构建时，选择是使用静态库还是共享库来构建。

当需要构建静态库时，可以将type设置为：

'type': 'static_library',
构建共享库时：

'type': 'shared_library',
添加一个平台相关的库

与添加平台相关的'可执行目标'一样，添加平台相关的库时，同样需要添加到conditions列表中：

{
  'targets': [
  ],
  'conditions': [
    ['OS=="win"', {
      'targets': [
        {
          'target_name': 'new_library',
          'type': '<(library)',
          'defines': [
            'FOO',
            'BAR=some_value',
          ],
          'include_dirs': [
            '..',
          ],
          'dependencies': [
            'other_target_in_this_file',
            'other_gyp2:target_in_other_gyp2',
          ],
          'direct_dependent_settings': {
            'include_dirs': '.',
          },
          'export_dependent_settings': [
            'other_target_in_this_file',
          ],
          'sources': [
            'new_additional_source.cc',
            'new_library.cc',
          ],
        },
      ],
    }],
  ],
}


5.6 两个目标之间的依赖关系
GYP提供了有用的原语来建立目标之间的依赖关系。

链接到另一个库目标

{
  'targets': [
    {
      'target_name': 'foo',
      'dependencies': [
        'libbar',
      ],
    },
    {
      'target_name': 'libbar',
      'type': '<(library)',
      'sources': [
      ],
    },
  ],
}
请注意，如果库目标位于不同的.gyp文件中，则必须指定相对于当前.gyp文件目录的其他.gyp文件的路径：

{
  'targets': [
    {
      'target_name': 'foo',
      'dependencies': [
        '../bar/bar.gyp:libbar',
      ],
    },
  ],
}
用库目标依赖关系编译必要的标志

我们需要使用特定的预处理器定义或命令行标记来构建一个库（通常是第三方库），并且需要确保依赖于库的目标使用相同的设置进行构建。 这种情况下可以由一个direct_dependent_settings块来处理的：

{
  'targets': [
    {
      'target_name': 'foo',
      'type': 'executable',
      'dependencies': [
        'libbar',
      ],
    },
    {
      'target_name': 'libbar',
      'type': '<(library)',
      'defines': [
        'LOCAL_DEFINE_FOR_LIBBAR',
        'DEFINE_TO_USE_LIBBAR',
      ],
      'include_dirs': [
        '..',
        'include/libbar',
      ],
      'direct_dependent_settings': {
        'defines': [
          'DEFINE_TO_USE_LIBBAR',
        ],
        'include_dirs': [
          'include/libbar',
        ],
      },
    },
  ],
}
当一个库在最后的链接时间依赖于另一个库

{
  'targets': [
    {
      'target_name': 'foo',
      'type': 'executable',
      'dependencies': [
        'libbar',
      ],
    },
    {
      'target_name': 'libbar',
      'type': '<(library)',
      'dependencies': [
        'libother'
      ],
      'export_dependent_settings': [
        'libother'
      ],
    },
    {
      'target_name': 'libother',
      'type': '<(library)',
      'direct_dependent_settings': {
        'defines': [
          'DEFINE_FOR_LIBOTHER',
        ],
        'include_dirs': [
          'include/libother',
        ],
      },
    },
  ],
}


5.7 支持Mac OS X绑定
gyp支持在OS X（.app、.framework、.bundle等）上构建捆绑包。如：

{
  'target_name': 'test_app',
  'product_name': 'Test App Gyp',
  'type': 'executable',
  'mac_bundle': 1,
  'sources': [
    'main.m',
    'TestAppAppDelegate.h',
    'TestAppAppDelegate.m',
  ],
  'mac_bundle_resources': [
    'TestApp/English.lproj/InfoPlist.strings',
    'TestApp/English.lproj/MainMenu.xib',
  ],
  'link_settings': {
    'libraries': [
      '$(SDKROOT)/System/Library/Frameworks/Cocoa.framework',
    ],
  },
  'xcode_settings': {
    'INFOPLIST_FILE': 'TestApp/TestApp-Info.plist',
  },
},
mac_bundle键告诉gyp这个目标应该是一个绑定包。 executable目标默认情况下扩展名是.app，shared_library目标获取.framework，但如果需要，可以通过设置product_extension来更改包扩展名。mac_bundle_resources中列出的文件将被复制到捆绑包的Resource文件夹中。还可以在操作和规则中将process_outputs_as_mac_bundle_resources设置为1，以便将操作和规则的输出添加到该文件夹（类似process_outputs_as_sources）。如果没有设置product_name，通常会使用target_name命名。