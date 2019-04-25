Shader "Custom/Blur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Blur ("Blur", Float) = 5 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			sampler2D _MainTex;
			uniform float4 _MainTex_TexelSize;

			float _Blur;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				int blur = max((int)_Blur, 0);

				if (blur == 0) {
					return tex2D(_MainTex, i.uv);
				}

				float2 texel = float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y);

				float3 avg = 0.0;

				for (int x = -blur; x <= blur; x++) {
					for (int y = -blur; y <= blur; y++) {
						avg += tex2D(_MainTex, i.uv + texel * float2(x, y));
					}
				}

				avg /= (blur * 2 + 1) * (blur * 2 + 1);

				return float4(avg, 1.0);
            }
            ENDCG
        }
    }
}
