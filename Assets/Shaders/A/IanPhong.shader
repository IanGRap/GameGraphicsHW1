Shader "Custom/IanPhong"
{
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_Shininess("Shininess", float) = 10
		_SpecColor("Specular Color", Color) = (1, 1, 1, 1)
	}

	SubShader{
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			//Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform float4 _LightColor0;
			sampler2D _MainTex;
			uniform float _Shininess;
			uniform float4 _SpecColor;

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 vertexInWorldCoords : TEXCOORD1;
			};

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = mul(unity_ObjectToWorld, v.normal);
				o.uv = v.uv;
				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				float3 P = i.vertexInWorldCoords.xyz;
				float3 N = normalize(i.normal);
				float3 V = _WorldSpaceCameraPos - P;
				float3 L = _WorldSpaceLightPos0.xyz - P;
				float3 H = normalize(V + L);

				float3 kd = tex2D(_MainTex, i.uv);
				float3 ka = UNITY_LIGHTMODEL_AMBIENT.rgb;
				// float3 ka = Color(0, 0, 1, 1);
				float3 ks = _SpecColor.rgb;
				float3 kl = _LightColor0.rgb;

				float3 ambient = ka * kd;

				float diffuseVal = max(dot(N, L), 0);
				float3 diffuse = kd * kl * diffuseVal;

				float specularVal = pow(max(dot(N, H), 0), _Shininess);
				if (diffuseVal == 0) {
					specularVal = 0;
				}
				float3 specular = ks * kl * specularVal;

				return float4(ambient + diffuse + specular, 1);
			}

			ENDCG
		}
        Pass {
            Tags { "LightMode" = "ForwardAdd" }
            Blend One One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform float4 _LightColor0;
            sampler2D _MainTex;
            uniform float _Shininess;
            uniform float4 _SpecColor;

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float3 vertexInWorldCoords : TEXCOORD1;
            };

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul(unity_ObjectToWorld, v.normal);
                o.uv = v.uv;
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float3 P = i.vertexInWorldCoords.xyz;
                float3 N = normalize(i.normal);
                float3 V = _WorldSpaceCameraPos - P;
                float3 L = _WorldSpaceLightPos0.xyz - P;
                float3 H = normalize(V + L);

                float3 kd = tex2D(_MainTex, i.uv);
                //float3 ka = UNITY_LIGHTMODEL_AMBIENT.rgb;
                float3 ka = float3(0, 0, 0.1);
                float3 ks = _SpecColor.rgb;
                float3 kl = _LightColor0.rgb;

                float3 ambient = ka;

                float diffuseVal = max(dot(N, L), 0);
                float3 diffuse = kd * kl * diffuseVal;

                float specularVal = pow(max(dot(N, H), 0), _Shininess);
                if (diffuseVal == 0) {
                    specularVal = 0;
                }
                float3 specular = ks * kl * specularVal;

                return float4(ambient + diffuse + specular, 1);
            }

            ENDCG
        }
	}
}
